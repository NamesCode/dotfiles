{
  config,
  lib,
  ...
}:
{
  options = {
    # Define variables here
    theming = {
      mainFont = lib.mkOption {
        description = "The font that all themed applications should follow";
        example = "Sans Serif";
        type = lib.types.str;
      };
      wallpaper = lib.mkOption {
        description = "The wallpaper that should be used";
        example = "./wallpaper.png";
        type = lib.types.path;
      };
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

  # Set values here
  # config = { };
}
