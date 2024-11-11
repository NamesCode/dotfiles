{
  config,
  lib,
  ...
}:
{
  # Define variables here
  options.vars = {
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

  # Set values here
  # config = {};
}
