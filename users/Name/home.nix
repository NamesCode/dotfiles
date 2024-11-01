{
  config,
  pkgs,
  ...
}:
let
  homeDir = "/home/Name";
  wallpaper = builtins.path { path = ../../modules/impure/wallpapers/garfield_wallpaper.png; name = "wallpaper"; };
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "Name";
  home.homeDirectory = homeDir;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    #pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

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

    configHome = "${homeDir}/.xdg/etc/";
    cacheHome = "${homeDir}/.xdg/var/cache/";
    dataHome = "/home/Name/.xdg/usr/share/";
    stateHome = "${homeDir}/.xdg/var/lib/";

    dataFile = {
      "scripts/screenshot.sh" = {
        enable = true;
        executable = true;
        source = ../../modules/impure/scripts/screenshot.sh;
      };
    };
  };

  # Imports the modules for different configs.
  imports = [ (import ./sway.nix { inherit config pkgs wallpaper; })
 ./bash.nix ./waybar.nix ./mako.nix ];

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
  home.sessionVariables = {
    EDITOR = "vim";
  };
  home.shellAliases = {
    # Sad times, I dont have my neovim conf. Once again I will steal winstons.
    "nvim" = "nix run github:nekowinston/neovim.drv -- ";
  };

  programs.git = {
    enable = true;
    userName = "Name";
    userEmail = "lasagna@garfunkles.space";

    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
