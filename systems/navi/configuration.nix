# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/apple-silicon-support

    # NOTE: ALVR currently doesnt support ARM, switch to it when it does.

    # Gaming

    # ## VR
    # ../../modules/nixos/monado.nix
    # WARN: Steam currently does not run on ARM
    # ## Stores
    # ../../modules/nixos/steam.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    # NOTE: Whilst I want to switch to ZFS, it requires me to reinstall Asahi NixOS
    # This is something I cannot be arsed to do at the moment
    # supportedFilesystems = [ "zfs" ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = false; # DO NOT CHANGE! uBoot manages this.
    };

    # Use tmpfs on /tmp
    tmp.useTmpfs = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  #  console = {
  #   font = "Lat2-Terminus16";
  #     keyMap = "mac-uk";
  #    useXkbConfig = true; # use xkb.options in tty.
  #  };
  #    boot.extraModprobeConfig = ''
  #  options hid_apple iso_layout=1
  # '';

  networking = {
    hostName = "navi";
    hostId = "fa2ae1ae";

    wireless.iwd = {
      enable = true;
      settings.General.EnableNetworkConfiguration = true;
    };
  };

  # Manage Nix itself
  nix = {
    # Enables flakes
    settings = {
      # Sets this to the correct location as /tmp is a tmpfs now
      build-dir = "/var/tmp";

      # Lets us use the better Nix cli and flakes as god intended
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    # Optimise the Nix store automagically
    optimise.automatic = true;

    # Manage the garbage collector
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  # Manage Nixpkgs
  nixpkgs.config.allowUnfree = true;

  # Allows NixOS to auto update.
  system.autoUpgrade.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.Name = {
    isNormalUser = true;
    home = "/home/Name";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [ firefox ];
  };

  # Security settings
  security = {
    # Desktop security stuff
    polkit.enable = true;

    # Requires that you use the root password instead of your current users when using sudo
    sudo.extraConfig = "Defaults rootpw";
  };

  home-manager = {
    useGlobalPkgs = true;
    users = {
      # Set my home-manager config
      "Name" = ../../users/Name/home.nix;
      # For future users
      # "Username" = ../../users/Username/home.nix;
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    brightnessctl # Screen brightness
    git # Git is essentially a system wide tool nowadays

    # This is needed for the Asahi Vulkan drivers
    mesa
    mesa.drivers

    # ZFS userspace tools
    # zfs

    # My Neovim flake (bracket to avoid 'with pkgs')
    (inputs.nvame.packages.${system}.mainConfig)
  ];

  hardware = {
    # Run the experimental vulkan driver NOTE: REMOVE IN FUTURE WHEN ITS STABLE
    asahi.useExperimentalGPUDriver = true;

    graphics = {
      enable = true;
      enable32Bit = lib.mkForce false;
    };

    # Enable bluetooth support
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  services = {
    # Allow a keyring for storing sensitive keys.
    gnome.gnome-keyring.enable = true;

    # Trackpad support
    libinput.enable = true;

    # Manage setup audio
    pipewire = {
      enable = true;
      pulse.enable = true;
    };

    # Set the keyboard layout.
    xserver.xkb.layout = "mac-GB";

    # Enable CUPS to print documents.
    printing.enable = true;

    # Smart card support
    pcscd.enable = true;
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 8080 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}
