# the Asahi Linux kernel and options that must go along with it

{ config, pkgs, lib, ... }:
{
  config = lib.mkIf config.hardware.asahi.enable {
    boot.kernelPackages = let
      pkgs' = config.hardware.asahi.pkgs;
    in
      pkgs'.linux-asahi.override {
        _kernelPatches = config.boot.kernelPatches;
        withRust = config.hardware.asahi.withRust;
      };

    # we definitely want to use CONFIG_ENERGY_MODEL, and
    # schedutil is a prerequisite for using it
    # source: https://www.kernel.org/doc/html/latest/scheduler/sched-energy.html
    powerManagement.cpuFreqGovernor = lib.mkOverride 800 "schedutil";

    # using an IO scheduler is pretty pointless on NVME devices as fast as Apple's
    # it's a waste of CPU cycles, so disable the IO scheduler on NVME
    # source: https://wiki.ubuntu.com/Kernel/Reference/IOSchedulers
    services.udev.extraRules = ''
      ACTION=="add|change", KERNEL=="nvme[0-9]*n[0-9]", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="none"
    '';
    # these two lines save 4 whole seconds during userspace boot, according to systemd-analyze.
    # if you're using a USB cellular internet modem (e.g. 4G, LTE, 5G, etc), then don't disable ModemManager
    systemd.services.mount-pstore.enable = false;
    systemd.services.ModemManager.enable = false;

    boot.initrd.includeDefaultModules = false;
    boot.initrd.availableKernelModules = [
      # list of initrd modules originally stolen by tpwrules from
      # https://github.com/AsahiLinux/asahi-scripts/blob/f461f080a1d2575ae4b82879b5624360db3cff8c/initcpio/install/asahi
      # refined by zzywysm to match his custom kernel configs
      "tps6598x"
      "dwc3"
      "dwc3-haps"
      "dwc3-of-simple"
      "xhci-pci"
      "phy-apple-atc"
      "phy-apple-dptx"
      "dockchannel-hid"
      "mux-apple-display-crossbar"
      "apple-dcp"
      "apple-z2"

      # additional stuff necessary to boot off USB for the installer
      # and if the initrd (i.e. stage 1) goes wrong
      "uas"
      "udc_core"
      "xhci-hcd"
      "usb-storage"
      "xhci-plat-hcd"
      "usbhid"
      "hid_generic"
    ];

    boot.kernelParams = [
      # nice insurance against f***ing up the kernel so much, the Mac no longer boots
      # (NixOS generations are another wonderful insurance policy, obvs)
      "boot.shell_on_fail"
      # most folks don't need these console specifiers
      # if you're doing kernel driver development, uncomment them
      # "console=ttySAC0,115200n8"
      # "console=tty0"
      # Apple's SSDs are slow (~dozens of ms) at processing flush requests which
      # slows down programs that make a lot of fsync calls. This parameter sets
      # a delay in ms before actually flushing so that such requests can be
      # coalesced. Be warned that increasing this parameter above zero (default
      # is 1000) has the potential, though admittedly unlikely, risk of
      # UNBOUNDED data corruption in case of power loss!!!! Don't even think
      # about it on desktops!!
      "nvme_apple.flush_interval=0"
      # make boot mostly silent, not because we don't appreciate the useful
      # information (we do), but because spew slows down boot
      "quiet"
      "loglevel=4"
      "systemd.show_status=auto"
      "rd.udev.log_level=4"
    ];

    # U-Boot does not support EFI variables
    boot.loader.efi.canTouchEfiVariables = lib.mkForce false;

    # U-Boot does not support switching console mode
    boot.loader.systemd-boot.consoleMode = "0";

    # GRUB has to be installed as removable if the user chooses to use it
    boot.loader.grub = lib.mkDefault {
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
    };

    # autosuspend was enabled as safe for the PCI SD card reader
    # "Genesys Logic, Inc GL9755 SD Host Controller [17a0:9755] (rev 01)"
    # by recent systemd versions, but this has a "negative interaction"
    # with our kernel/SoC and causes random boot hangs. disable it!
    services.udev.extraHwdb = ''
      pci:v000017A0d00009755*
        ID_AUTOSUSPEND=0
    '';
  };

  imports = [
    (lib.mkRemovedOptionModule [ "hardware" "asahi" "addEdgeKernelConfig" ]
      "All edge kernel config options are now the default.")
  ];

  options.hardware.asahi.withRust = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = ''
      Build the Asahi Linux kernel with Rust support.
    '';
  };
}
