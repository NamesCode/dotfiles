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
  # Configure tofi
  programs.tofi = {
    enable = isLinux;
    settings = {
      # Fullscreen theme
      width = "100%";
      height = "100%";
      border-width = 0;
      outline-width = 0;
      padding-left = "35%";
      padding-top = "35%";
      result-spacing = 25;
      num-results = 5;
      font = "${config.theming.mainFont}";

      # Theme
      text-color = "${colours.subtext}";
      prompt-color = "${colours.mainAccent}";
      selection-color = "${colours.text}";
      background-color = "${colours.base}DD";
    };
  };
}
