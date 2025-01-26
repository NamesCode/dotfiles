{
  config,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
in
{
  # Configure mako
  services.mako = {
    enable = isLinux;
    width = 350;
    textColor = "#cdd6f4";
    borderColor = "#f38ba8";
    borderSize = 2;
    backgroundColor = "#1e1e2e";
    progressColor = "#313244";
    layer = "overlay";
    sort = "+priority";
    font = "${config.theming.mainFont}";
  };
}
