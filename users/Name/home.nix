{
  lib,
  config,
  pkgs,
  nurrrr-pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "Name";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # Lets the system find fonts when installed through HM
  fonts.fontconfig.enable = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages =
    with pkgs;
    [
      # Install nerd-fonts
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono

      # View system resource usage nicely
      htop
      ncdu

      # Better tools
      ripgrep
      fd
      lsd

      # Security stuff
      yubikey-manager
      age

      # Multi-media
      mplayer

      # Chat clients
      vesktop # Wayy better than discord and cross platform

      # Connect to android devices
      android-tools

      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')
    ]
    ++ lib.optionals isLinux [
      # Multi-media
      vlc
    ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # XDG setup
  xdg = {
    enable = true;

    configHome = "${config.home.homeDirectory}/.xdg/etc";
    cacheHome = "${config.home.homeDirectory}/.xdg/var/cache";
    dataHome = "${config.home.homeDirectory}/.xdg/usr/share";
    stateHome = "${config.home.homeDirectory}/.xdg/var/lib";

    userDirs = {
      enable = isLinux;
      createDirectories = true;

      desktop = "${config.home.homeDirectory}";
      download = "${config.home.homeDirectory}/downloads";
      documents = "${config.home.homeDirectory}/documents";
      templates = "${config.home.homeDirectory}/documents/templates";
      music = "${config.home.homeDirectory}/media/music";
      pictures = "${config.home.homeDirectory}/media/images";
      videos = "${config.home.homeDirectory}/media/videos";
      publicShare = "${config.home.homeDirectory}/public";
      extraConfig = {
        XDG_CODE_DIR = "${config.home.homeDirectory}/documents/code";
      };
    };

    dataFile = {
      # Copies all my scripts to the xdg scripts folder. NOTE: MAKE SURE TO `chmod +x` THE SCRIPT FIRST!!
      "scripts" = {
        recursive = true;
        source = ../../modules/impure/scripts;
      };
    };
  };

  # Define variables used across modules
  theming = {
    mainFont = "JetBrains Mono";
    opacity = 0.98;

    # colours = { };

    # wallpaper = ../../modules/impure/wallpapers/shinji-x-kaworu/beach.jpg;
    wallpaper = ../../modules/impure/wallpapers/garfield_wallpaper.png;
  };

  windowManager = lib.mkIf isDarwin "yabai";

  # Imports the modules for different configs.
  imports = [
    # WM setup

    ## Linux
    ./sway.nix
    ./waybar.nix
    ./mako.nix
    ./tofi.nix

    ## Darwin
    # ./yabai.nix

    # Terminal
    ./alacritty.nix

    # Shell
    ./zsh.nix

    # Dev toolings
    ../../modules/home-manager/direnv.nix
    ./git.nix

    # Password management
    ./password.nix

    # The dotfile lib
    ../../modules/home-manager/lib

    # Chosen theme
    ../../modules/home-manager/themes/catppuccin/mocha.nix # Dark ctp
    # ../../modules/home-manager/themes/catppuccin/latte.nix # Light ctp
  ];

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/Name/etc/profile.d/hm-session-vars.sh
  #

  # NOTE: THESE OPTIONS REQUIRE A REBOOT TO TAKE AFFECT
  # Sets environment variables for my user
  home.sessionVariables = {
    EDITOR = "nvim";
  };
  # Adds directorys to path
  home.sessionPath = [
    "${config.xdg.dataHome}/scripts"
  ];
  # Sets up shell aliases
  home.shellAliases = {
    # Since Hyfetch doesn't respect XDG on NixOS for some reason
    hyfetch = "hyfetch -C ${config.xdg.configHome}/hyfetch.json";
    vim = "nvim";
    ls = "lsd";

    # Quick FS travel
    code = "cd $XDG_CODE_DIR && ls";
    images = "cd $XDG_PICTURES_DIR && ls";
    videos = "cd $XDG_VIDEOS_DIR && ls";
    music = "cd $XDG_MUSIC_DIR && ls";
    books = "cd ~/media/books && ls";
    diary = "cd $XDG_DOCUMENTS_DIR/diary && ls";
    dotfiles = "cd $XDG_CODE_DIR/dotfiles && $EDITOR";
  };

  # Run the SSH agent on startup
  services.ssh-agent.enable = isLinux;

  # Makes my fetch ✨ G A Y ✨
  programs.hyfetch = {
    enable = true;
    settings = {
      preset = "gay-men";
      mode = "rgb";
      light_dark = "dark";
      lightness = 0.6;
      color_align = {
        mode = if isDarwin then "vertical" else "horizontal";
        custom_colors = [ ];
        fore_back = null;
      };
      backend = "neofetch";
      args = null;
      distro = null;
      pride_month_shown = [ ];
      pride_month_disable = false;
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
