{
  config,
  pkgs,
  ...
}: {
  # Setup gpg
  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gpg";
  };
 
  # Setup gpg-agent
  services.gpg-agent = {
    enableBashIntegration = true;
    enableScDaemon = true;
  };
}
