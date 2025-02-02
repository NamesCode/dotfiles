{
  config,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
  colours = config.theming.colours;
in
{
  # Configure mako
  services.mako = {
    enable = isLinux;
    width = 350;
    textColor = "${colours.text}";
    borderColor = "${colours.mainAccent}";
    borderSize = 2;
    backgroundColor = "${colours.base}";
    progressColor = "#313244";
    layer = "overlay";
    sort = "+priority";
    font = "${config.theming.mainFont}";
  };
}
