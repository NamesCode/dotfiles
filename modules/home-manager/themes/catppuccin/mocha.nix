{ config, ... }:
{
  theming.colours = {
    # Secondary pallette for ANSI
    ansi = {
      # Normal colours
      black = "#585b70";
      red = "#f38ba8";
      green = "#a6e3a1";
      yellow = "#f9e2af";
      blue = "#89b4fa";
      magenta = "#f5c2e7";
      cyan = "#94e2d5";
      white = "#bac2de";

      bright = {
        # Bright colours
        black = "#525679";
        red = "#f77b9d";
        green = "#8edd90";
        yellow = "#f1d895";
        blue = "#78acff";
        magenta = "#f7b3e2";
        cyan = "#70dcce";
        white = "#aeb9e4";
      };
    };

    # Special colours.
    mainAccent = config.theming.colours.red;
    secondaryAccent = config.theming.colours.maroon;

    # Shades
    text = "#cdd6f4";
    subtext = "#a6adc8";
    overlay = "#6c7086";
    surface = "#313244";
    base = "#1e1e2e";
    mantle = "#181825";
    crust = "#11111b";

    # 🌈 R A I N B O W 🌈 (gay)
    red = "#f38ba8";
    maroon = "#eba0ac";
    orange = "#fab387";
    yellow = "#f9e2af";
    green = "#a6e3a1";
    teal = "#94e2d5";
    sky = "#89dceb";
    sapphire = "#74c7ec";
    blue = "#89b4fa";
    purple = "#cba6f7";
    lavender = "#b4befe";
    pink = "#f5c2e7";
  };
}
