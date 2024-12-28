{
  config,
  pkgs,
  ...
}:
{
  # Setup bash
  programs.bash = {
    enable = true;
    enableCompletion = true;
    historySize = 100;
    historyFileSize = 100000;
    historyControl = [ "erasedups" ];
    profileExtra = "echo 'hai haiii haiiiiii~ <3'";
    bashrcExtra = ''
      # Sets Vi mode on the shell
      set -o vi
    '';
  };
}
