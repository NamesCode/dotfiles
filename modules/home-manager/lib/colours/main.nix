{ lib, ... }:
{
  options = {
    theming.colours = lib.mkOption {
      description = "Colour options that apps will follow.";
      example = (
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
                cyan = "#70dcc";
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
      );
      type = lib.types.submodule ({
        options = {
          # Special colours.
          mainAccent = lib.mkOption {
            description = "The primary accent colour. Often we just call a different colour defined here.";
            example = "\${config.theming.colours.red}";
            type = lib.types.strMatching "[#0-9A-Fa-f]{3,9}"; # Ensures it is a valid HexCode
          };
          secondaryAccent = lib.mkOption {
            description = "The secondary accent colour. Often we just call a different colour defined here.";
            example = "\${config.theming.colours.maroon}";
            type = lib.types.strMatching "[#0-9A-Fa-f]{3,9}"; # Ensures it is a valid HexCode
          };

          # Shades
          text = lib.mkOption {
            description = "The colour used for text.";
            example = "#cdd6f4";
            type = lib.types.strMatching "[#0-9A-Fa-f]{3,9}"; # Ensures it is a valid HexCode
          };
          subtext = lib.mkOption {
            description = "The colour used for subtext.";
            example = "#a6adc8";
            type = lib.types.strMatching "[#0-9A-Fa-f]{3,9}"; # Ensures it is a valid HexCode
          };
          overlay = lib.mkOption {
            description = "The lightest (dark) or darkest (light) shade of gray.";
            example = "#6c7086";
            type = lib.types.strMatching "[#0-9A-Fa-f]{3,9}"; # Ensures it is a valid HexCode
          };
          surface = lib.mkOption {
            description = "A middle ground shade.";
            example = "#313244";
            type = lib.types.strMatching "[#0-9A-Fa-f]{3,9}"; # Ensures it is a valid HexCode
          };
          base = lib.mkOption {
            description = "The background colour.";
            example = "#1e1e2e";
            type = lib.types.strMatching "[#0-9A-Fa-f]{3,9}"; # Ensures it is a valid HexCode
          };
          mantle = lib.mkOption {
            description = "Complementary shade to the background colour.";
            example = "#181825";
            type = lib.types.strMatching "[#0-9A-Fa-f]{3,9}"; # Ensures it is a valid HexCode
          };
          crust = lib.mkOption {
            description = "The darkest (dark) or lightest (light) colour.";
            example = "#11111b";
            type = lib.types.strMatching "[#0-9A-Fa-f]{3,9}"; # Ensures it is a valid HexCode
          };

          # 🌈 R A I N B O W 🌈 (gay)
          red = lib.mkOption {
            description = "The red colour to be used.";
            example = "#f38ba8";
            type = lib.types.strMatching "[#0-9A-Fa-f]{3,9}"; # Ensures it is a valid HexCode
          };
          maroon = lib.mkOption {
            description = "A lighter shade of red.";
            example = "#eba0ac";
            type = lib.types.strMatching "[#0-9A-Fa-f]{3,9}"; # Ensures it is a valid HexCode
          };
          orange = lib.mkOption {
            description = "The orange colour to be used.";
            example = "#fab387";
            type = lib.types.strMatching "[#0-9A-Fa-f]{3,9}"; # Ensures it is a valid HexCode
          };
          yellow = lib.mkOption {
            description = "The yellow colour to be used.";
            example = "#f9e2af";
            type = lib.types.strMatching "[#0-9A-Fa-f]{3,9}"; # Ensures it is a valid HexCode
          };
          green = lib.mkOption {
            description = "The green colour to be used.";
            example = "#a6e3a1";
            type = lib.types.strMatching "[#0-9A-Fa-f]{3,9}"; # Ensures it is a valid HexCode
          };
          teal = lib.mkOption {
            description = "The lightest shade of blue.";
            example = "#94e2d5";
            type = lib.types.strMatching "[#0-9A-Fa-f]{3,9}"; # Ensures it is a valid HexCode
          };
          sky = lib.mkOption {
            description = "The second lightest shade of blue.";
            example = "#89dceb";
            type = lib.types.strMatching "[#0-9A-Fa-f]{3,9}"; # Ensures it is a valid HexCode
          };
          sapphire = lib.mkOption {
            description = "The second darkest shade of blue.";
            example = "#74c7ec";
            type = lib.types.strMatching "[#0-9A-Fa-f]{3,9}"; # Ensures it is a valid HexCode
          };
          blue = lib.mkOption {
            description = "The darkest shade of blue.";
            example = "#89b4fa";
            type = lib.types.strMatching "[#0-9A-Fa-f]{3,9}"; # Ensures it is a valid HexCode
          };
          purple = lib.mkOption {
            description = "The purple colour to be used.";
            example = "#cba6f7";
            type = lib.types.strMatching "[#0-9A-Fa-f]{3,9}"; # Ensures it is a valid HexCode
          };
          lavender = lib.mkOption {
            description = "The lavender colour to be used.";
            example = "#b4befe";
            type = lib.types.strMatching "[#0-9A-Fa-f]{3,9}"; # Ensures it is a valid HexCode
          };
          pink = lib.mkOption {
            description = "The pink colour to be used.";
            example = "#f5c2e7";
            type = lib.types.strMatching "[#0-9A-Fa-f]{3,9}"; # Ensures it is a valid HexCode
          };
        };
      });
    };
  };
}
