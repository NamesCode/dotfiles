{
  config,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
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

      # Catppuccin Mocha
      text-color = "#7f849c";
      prompt-color = "#f38ba8";
      selection-color = "#cdd6f4";
      background-color = "#1e1e2eDD";
    };
  };
}
