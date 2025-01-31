{
  config,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
  colour = config.theming.colour;
in
{
  # Configure mako
  services.mako = {
    enable = isLinux;
    width = 350;
    textColor = "${colour.text}";
    borderColor = "${colour.mainAccent}";
    borderSize = 2;
    backgroundColor = "${colour.base}";
    progressColor = "#313244";
    layer = "overlay";
    sort = "+priority";
    font = "${config.theming.mainFont}";
  };
}
