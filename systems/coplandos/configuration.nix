{
  config,
  pkgs,
  nvame,
  ...
}:
{
  imports = [
    ./wm.nix
  ];

  # Set your time zone.
  time.timeZone = "Europe/London";

  networking = {
    hostName = "coplandos";
  };

  # Manage Nix itself
  nix = {
    # Enables flakes
    settings = {
      # Sets this to the /var/tmp for consistency across systems
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
      interval = [ { Weekday = 7; } ];
      options = "--delete-older-than 14d";
    };
  };

  # Defines the users as necessary for home-manager
  users.users.Name.home = "/Users/Name";

  # Manage Nixpkgs
  nixpkgs.config.allowUnfree = true;

  # Security settings
  # security = { };

  home-manager.users = {
    # Set my home-manager config
    "Name" = ../../users/Name/home.nix;
    # For future users
    # "Username" = ../../users/Username/home.nix;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git # Git is essentially a system wide tool nowadays
    # sshfs

    # My Neovim flake (bracket to avoid 'with pkgs')
    (nvame.mainConfig)
  ];

  homebrew = {
    enable = true;
    caskArgs.require_sha = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
      upgrade = true;
    };
    casks =
      let
        skipSha = name: {
          inherit name;
          args = {
            require_sha = false;
          };
        };
        noQuarantine = name: {
          inherit name;
          args = {
            no_quarantine = true;
          };
        };
      in
      [
        # Media
        "blender"
        "obs"
        "vlc"

        # User
        "firefox"
        "mullvadvpn"
        "qbittorrent"

        # Games
        "osu"
        "whisky"
        "prismlauncher"

        # Dev
        (noQuarantine "alacritty")
        "utm"
        "balenaetcher"
        "godot"
        "renpy"
        "dbeaver-community"

        # System
        "appcleaner"
        "aldente"
        # "macfuse" # BUG: macOS bug causes System Error loop. Search "macfuse system extension error 14.6". You gotta do DFU or smth
        # "openzfs"
        # NOTE: I would prefer macfuse but this'll work for now
        "fuse-t"
        "fuse-t-sshfs"
      ];
    taps = [ "macos-fuse-t/homebrew-cask" ];
    # extraConfig = '''';
  };

  services = {
    ## Enables borders for yabai wm
    #jankyborders.enable = true;

    ## Enables the skhd hotkey daemon
    #skhd.enable = true;
  };

  system.stateVersion = 5; # WARN: DO NOT CHANGE APPARENTLY
}
