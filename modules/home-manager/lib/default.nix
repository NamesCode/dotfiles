{ lib, ... }:
{
  imports = [ ./colours ];

  options = {
    # Define variables here
    theming = lib.mkOption {
      description = "Theming options";
      type = lib.types.submodule ({
        options = {
          mainFont = lib.mkOption {
            description = "The font that all themed applications should follow";
            example = "Sans Serif";
            type = lib.types.str;
          };

          opacity = lib.mkOption {
            description = "Set the opacity level for all apps with opacity enabled";
            example = "0.98";
            type = lib.types.float;
          };

          wallpaper = lib.mkOption {
            description = "The wallpaper that should be used";
            example = "./wallpaper.png";
            type = lib.types.path;
          };
        };
      });
    };

    windowManager = lib.mkOption {
      description = "The window manager to be used";
      example = "sway";
      type = lib.types.enum [
        "sway"
        "yabai"
      ];
      default = "sway";
    };
  };
}
