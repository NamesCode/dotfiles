# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # Uses the shared config for servers
    ../../../modules/nixos/servers

    # Server modules
    ../../../modules/nixos/servers/git.nix
    # ../../../modules/nixos/servers/haproxy.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "melchior";

    # Sets hostId as required by ZFS
    hostId = "efb68931";
  };

  # Automagically update DNS entries with a tool made by moi ✨
  services.ddnsh = {
    enable = true;
    user = "root";

    zoneId = "beaa649556618108a535c4e9b32473c5";
    apiKeyFile = "This is left blank intentionally. fill this in l8r also ITS A SECRET";
  };

  # Set your time zone.
  time.timeZone = "Europe/London";

  users.users = {
    # Name is specified by the default setup

    HPsaucii = {
      isNormalUser = true;
      extraGroups = [
        "allowed-ssh"
        "allowed-nix"
      ];

      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFvhyZYJ2RTlJuKvcORZaT5AOzLRVrYmp21Rhpa4u/EM me@hpsaucii.dev"
      ];
    };

    Ella = {
      isNormalUser = true;
      extraGroups = [
        "allowed-ssh"
        "allowed-nix"
      ];

      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOJG+RdpIX6sblTrd6c9oxus+/LvupgDVcybtLBpu99d niko123we@Niko"
      ];
    };
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.

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
