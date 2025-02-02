{
  lib,
  config,
  pkgs,
  nvame,
  ...
}:
{
  # This is a default server config for quick setup

  # Imports other modules
  imports = [
    ./ssh.nix
    # ../zfs.nix
  ];

  # Users
  users = {
    mutableUsers = true;

    # Defines users
    users.Name = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "allowed-ssh"
        "allowed-nix"
      ];

      packages = [
        nvame.default
      ];

      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAZHrz913rUEzlnW3o6UjySbOaYYA+3F3oYFHk9xTPNy Name@coplandos"
      ];
    };

    # Defines groups
    groups = {
      allowed-ssh = { };
      allowed-nix = { };
    };
  };

  # Setup environment packages
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    git
    wget
    htop
    hyfetch
  ];

  # use tmpfs for /tmp
  boot.tmp.useTmpfs = true;

  # Manage Nix itself
  nix = {
    # Enables flakes
    settings = {
      # Sets this to the correct location as /tmp is a tmpfs now
      build-dir = "/var/tmp";

      # More privilages Nix access
      trusted-users = [ "@wheel" ];

      # Makes it so that only allowed users may access Nix
      allowed-users = [ "@allowed-nix" ];

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

  # Security settings
  security = {
    # Requires that you use the root password instead of your current users when using sudo
    sudo.extraConfig = "Defaults rootpw";
  };
}
