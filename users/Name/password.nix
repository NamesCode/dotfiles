{
  lib,
  config,
  pkgs,
  ...
}:
{
  # Configure tofi
  programs.password-store = {
    enable = true;
    package = pkgs.passage;

    settings = {
      # Passage specific
      PASSAGE_DIR = "${config.xdg.configHome}/passage/store/";
      PASSAGE_IDENTITIES_FILE = "${config.xdg.configHome}/passage/identities";
    };
  };

  home.activation.myScript = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p ${config.xdg.configHome}/passage/store
    if [ ! -d "${config.xdg.configHome}/passage/store/.git" ]; then
      echo -e "\033[43m\033[1;30mINFO:\033[0m OI, make sure you clone your password repo! \`git clone git@git.puppyboy.cloud/Name/passwords ${config.xdg.configHome}/passage/store/\`"
    fi
  '';
}
