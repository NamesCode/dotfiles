{ lib, ... }:
{
  options = {
    # Secondary pallette for ANSI
    theming.colours.ansi = lib.mkOption {
      description = "Sets the colours for the ANSI pallette.";
      type = lib.types.submodule ({
        options = {
          # Normal colours
          black = lib.mkOption {
            description = "The black ANSI colour to be used.";
            example = "#000000";
            type = lib.types.strMatching "[#0-9A-Fa-f]{,9}"; # Ensures it is a valid HexCode
          };
          red = lib.mkOption {
            description = "The red ANSI colour to be used.";
            example = "#aa0000";
            type = lib.types.strMatching "[#0-9A-Fa-f]{,9}"; # Ensures it is a valid HexCode
          };
          green = lib.mkOption {
            description = "The green ANSI colour to be used.";
            example = "#00aa00";
            type = lib.types.strMatching "[#0-9A-Fa-f]{,9}"; # Ensures it is a valid HexCode
          };
          yellow = lib.mkOption {
            description = "The yellow ANSI colour to be used.";
            example = "#aa5500";
            type = lib.types.strMatching "[#0-9A-Fa-f]{,9}"; # Ensures it is a valid HexCode
          };
          blue = lib.mkOption {
            description = "The blue ANSI colour to be used.";
            example = "#0000aa";
            type = lib.types.strMatching "[#0-9A-Fa-f]{,9}"; # Ensures it is a valid HexCode
          };
          magenta = lib.mkOption {
            description = "The magenta ANSI colour to be used.";
            example = "#aa00aa";
            type = lib.types.strMatching "[#0-9A-Fa-f]{,9}"; # Ensures it is a valid HexCode
          };
          cyan = lib.mkOption {
            description = "The cyan ANSI colour to be used.";
            example = "#00aaaa";
            type = lib.types.strMatching "[#0-9A-Fa-f]{,9}"; # Ensures it is a valid HexCode
          };
          white = lib.mkOption {
            description = "The white ANSI colour to be used.";
            example = "#aaaaaa";
            type = lib.types.strMatching "[#0-9A-Fa-f]{,9}"; # Ensures it is a valid HexCode
          };

          bright = lib.mkOption {
            description = "Sets the colours for the bright ANSI pallette.";
            type = lib.types.submodule ({
              options = {
                # Bright colours
                black = lib.mkOption {
                  description = "The bright black ANSI colour to be used.";
                  example = "#555555";
                  type = lib.types.strMatching "[#0-9A-Fa-f]{,9}"; # Ensures it is a valid HexCode
                };
                red = lib.mkOption {
                  description = "The bright red ANSI colour to be used.";
                  example = "#ff5555";
                  type = lib.types.strMatching "[#0-9A-Fa-f]{,9}"; # Ensures it is a valid HexCode
                };
                green = lib.mkOption {
                  description = "The bright green ANSI colour to be used.";
                  example = "#55ff55";
                  type = lib.types.strMatching "[#0-9A-Fa-f]{,9}"; # Ensures it is a valid HexCode
                };
                yellow = lib.mkOption {
                  description = "The bright yellow ANSI colour to be used.";
                  example = "#ffff55";
                  type = lib.types.strMatching "[#0-9A-Fa-f]{,9}"; # Ensures it is a valid HexCode
                };
                blue = lib.mkOption {
                  description = "The bright blue ANSI colour to be used.";
                  example = "#5555ff";
                  type = lib.types.strMatching "[#0-9A-Fa-f]{,9}"; # Ensures it is a valid HexCode
                };
                magenta = lib.mkOption {
                  description = "The bright magenta ANSI colour to be used.";
                  example = "#ff55ff";
                  type = lib.types.strMatching "[#0-9A-Fa-f]{,9}"; # Ensures it is a valid HexCode
                };
                cyan = lib.mkOption {
                  description = "The bright cyan ANSI colour to be used.";
                  example = "#55ffff";
                  type = lib.types.strMatching "[#0-9A-Fa-f]{,9}"; # Ensures it is a valid HexCode
                };
                white = lib.mkOption {
                  description = "The bright white ANSI colour to be used.";
                  example = "#ffffff";
                  type = lib.types.strMatching "[#0-9A-Fa-f]{,9}"; # Ensures it is a valid HexCode
                };
              };
            });
          };
        };
      });
    };
  };
}
