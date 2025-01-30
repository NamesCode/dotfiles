{ config, ... }:
{
  theming.colours = {
    # Special colours.
    mainAccent = config.theming.colours.red;
    secondaryAccent = config.theming.colours.maroon;

    # Shades
    text = "#4c4f69";
    subtext = "#6c6f85";
    overlay = "#9ca0b0";
    surface = "#ccd0da";
    base = "#eff1f5";
    mantle = "#e6e9ef";
    crust = "#dce0e8";

    # 🌈 R A I N B O W 🌈 (gay)
    red = "#d20f39";
    maroon = "#e64553";
    orange = "#fe640b";
    yellow = "#df8e1d";
    green = "#40a02b";
    teal = "#179299";
    sky = "#04a5e5";
    sapphire = "#209fb5";
    blue = "#1e66f5";
    purple = "#8839ef";
    lavender = "#7287fd";
    pink = "#ea76cb";
  };
}
