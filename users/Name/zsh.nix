{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
in
{
  # Setup zsh
  programs.zsh = {
    enable = isDarwin;
    plugins = [
      # Wayyyyyy better Vi mode + it has Vim extras :00
      {
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
    ];

    # Syntax and interactive use stuff
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    autocd = true;

    # Config and history related settings
    dotDir = "${config.xdg.dataHome}/zsh";
    history = {
      size = 10000;
      ignoreDups = true;
      expireDuplicatesFirst = true;
    };
    historySubstringSearch.enable = true;

    # Effect RC's directly
    loginExtra = "echo 'hai haiii haiiiiii~ <3'";
    profileExtra = "eval `ssh-agent` &> /dev/null";
  };

  home.activation = {
    makeZshDir = lib.hm.dag.entryAfter [ "writeBoundary" ] "mkdir -p ${config.xdg.dataHome}/zsh";
  };
}
