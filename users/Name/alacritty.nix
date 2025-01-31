{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;

  font =
    if (config.theming.mainFont == "JetBrains Mono" && isDarwin) then
      "JetBrainsMono"
    else
      config.theming.mainFont;
in
{
  # Installs alacritty if we're on a Linux host
  programs.alacritty.enable = isLinux;

  # xdg.configFile."alacritty.toml".text = ''
  home.file.".config/alacritty.toml".text = ''
    [window]
    decorations = "None"
    opacity = ${lib.strings.floatToString config.theming.opacity}
    startup_mode = "Maximized"

    [font]
    normal = { family = "${font} NF" }
  '';
}
