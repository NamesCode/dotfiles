## This file is based of MIT licensed code belonging to https://github.com/tpwrules/nixos-apple-silicon
## To respect the license here is the MIT license and it's notice.
## Changes to this MIT code are now in MPL-2.0 and are copyright of Name

# Copyright (c) 2021 Thomas Watson
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.

{
  config,
  pkgs,
  lib,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/profiles/minimal.nix")
    (modulesPath + "/profiles/installation-device.nix")
    (modulesPath + "/installer/cd-dvd/iso-image.nix")
  ];

  # Adds terminus_font for people with HiDPI displays
  console.packages = [ pkgs.terminus_font ];

  # ISO naming.
  isoImage.isoName = "nixos-asahi-zfs-${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}.iso";

  # EFI booting
  isoImage.makeEfiBootable = true;

  # An installation media cannot tolerate a host config defined file
  # system layout on a fresh machine, before it has been formatted.
  swapDevices = lib.mkOverride 60 [ ];
  fileSystems = lib.mkOverride 60 config.lib.isoFileSystems;

  boot.postBootCommands =
    let
      inherit (config.hardware.asahi.pkgs) asahi-fwextract;
    in
    ''
      for o in $(</proc/cmdline); do
        case "$o" in
          live.nixos.passwd=*)
            set -- $(IFS==; echo $o)
            echo "nixos:$2" | ${pkgs.shadow}/bin/chpasswd
            ;;
        esac
      done

      echo Extracting Asahi firmware...
      mkdir -p /tmp/.fwsetup/{esp,extracted}

      mount /dev/disk/by-partuuid/`cat /proc/device-tree/chosen/asahi,efi-system-partition` /tmp/.fwsetup/esp
      ${asahi-fwextract}/bin/asahi-fwextract /tmp/.fwsetup/esp/asahi /tmp/.fwsetup/extracted
      umount /tmp/.fwsetup/esp

      pushd /tmp/.fwsetup/
      cat /tmp/.fwsetup/extracted/firmware.cpio | ${pkgs.cpio}/bin/cpio -id --quiet --no-absolute-filenames
      mkdir -p /lib/firmware
      mv vendorfw/* /lib/firmware
      popd
      rm -rf /tmp/.fwsetup
    '';

  # can't legally be incorporated into the installer image
  # (and is automatically extracted at boot above)
  hardware.asahi.extractPeripheralFirmware = false;

  isoImage.squashfsCompression = "zstd -Xcompression-level 6";

  # Enable support for the ZFS filesystem
  boot.supportedFilesystems = [ "zfs" ];

  environment.systemPackages = with pkgs; [
    # File system tools
    zfs

    # Partitioning tools
    gptfdisk
    parted

    # Disk encryption
    cryptsetup

    # Network tools
    curl
    wget
    git
  ];

  # save space and compilation time. might revise?
  hardware.enableAllFirmware = lib.mkForce false;
  hardware.enableRedistributableFirmware = lib.mkForce false;
  hardware.pulseaudio.enable = false;
  hardware.asahi.setupAsahiSound = false;
  # avoid including non-reproducible dbus docs
  documentation.doc.enable = false;
  documentation.info.enable = lib.mkForce false;
  documentation.nixos.enable = lib.mkOverride 49 false;
  system.extraDependencies = lib.mkForce [ ];

  # Disable wpa_supplicant because it can't use WPA3-SAE on broadcom chips that are used on macs and it is harder to use and less mainained than iwd in general
  networking.wireless.enable = false;
  # Enable iwd
  networking.wireless.iwd = {
    enable = true;
    settings.General.EnableNetworkConfiguration = true;
  };

  nixpkgs.overlays = [
    (final: prev: {
      # disabling pcsclite avoids the need to cross-compile gobject
      # introspection stuff which works now but is slow and unnecessary
      libfido2 = prev.libfido2.override {
        withPcsclite = false;
      };
      openssh = prev.openssh.overrideAttrs (old: {
        # we have to cross compile openssh ourselves for whatever reason
        # but the tests take quite a long time to run
        doCheck = false;
      });

      # avoids having to compile a bunch of big things (like texlive) to
      # compute translations
      util-linux = prev.util-linux.override {
        translateManpages = false;
      };
    })
  ];

  # avoids the need to cross-compile gobject introspection stuff which works
  # now but is slow and unnecessary
  security.polkit.enable = lib.mkForce false;

  # bootspec generation is currently broken under cross-compilation
  boot.bootspec.enable = false;

  # get rid of warning about non-ideal mdam config file
  # (we want to keep it enabled in case someone needs to use it)
  boot.swraid.mdadmConf = ''
    PROGRAM ${pkgs.coreutils}/bin/true
  '';

  # avoid error that flakes must be enabled when nixos-install uses <nixpkgs>
  nixpkgs.flake.setNixPath = false;
  nixpkgs.flake.setFlakeRegistry = false;

  # get rid of warning that stateVersion is unset
  system.stateVersion = lib.mkDefault lib.trivial.release;
}
