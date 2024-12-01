{
  config,
  pkgs,
  ...
}:
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "Name";
  home.homeDirectory = "/home/${config.home.username}";

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
  home.packages = with pkgs; [
    # Install patches dev fonts
    (pkgs.nerdfonts.override {
      fonts = [
        "FiraCode"
        "JetBrainsMono"
      ];
    })

    # View system resource usage nicely
    htop

    # Better tools
    ripgrep
    fd
    lsd

    # Yubikey stuff
    yubikey-manager

    # Multi-media
    vlc

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
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
      enable = true;
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
        XDG_CODE_DIR = "${config.home.homeDirectory}/projects";
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
  vars = {
    mainFont = "JetBrains Mono";
    wallpaper = ../../modules/impure/wallpapers/shinji-x-kaworu/beach.jpg;
  };

  # Imports the modules for different configs.
  imports = [
    # WM setup
    ./sway.nix
    ./waybar.nix
    ./mako.nix
    ./tofi.nix

    # Shell
    ./bash.nix

    # Terminal
    ./foot.nix

    # The dotfile lib
    ../../modules/home-manager/lib.nix
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
  };

  # Run the SSH agent on startup
  services.ssh-agent.enable = true;

  # Configures git
  programs.git = {
    enable = true;
    userName = "Name";
    userEmail = "lasagna@garfunkles.space";

    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  # Sets up Nix-Direnv
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  # Makes my fetch ✨ G A Y ✨
  programs.hyfetch = {
    enable = true;
    settings = {
      preset = "gay-men";
      mode = "rgb";
      light_dark = "dark";
      lightness = 0.6;
      color_align = {
        mode = "horizontal";
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
