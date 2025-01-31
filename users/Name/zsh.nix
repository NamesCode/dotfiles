{
  config,
  pkgs,
  ...
}:
{
  # Setup zsh
  programs.zsh = {
    enable = true;
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
    dotDir = ".xdg/etc/zsh"; # NOTE: dotDir is relative so we *cannot* use xdg.configHome
    history = {
      size = 10000;
      ignoreDups = true;
      expireDuplicatesFirst = true;
    };
    historySubstringSearch.enable = true;

    # Effect RC's directly
    loginExtra = "echo 'hai haiii haiiiiii~ <3'";
    profileExtra = ''
      eval `ssh-agent` &> /dev/null
      prompt suse

      ZVM_VI_HIGHLIGHT_FOREGROUND=bright_black
      ZVM_VI_HIGHLIGHT_BACKGROUND=red
      ZVM_VI_HIGHLIGHT_EXTRASTYLE=bold
    '';
  };
}
