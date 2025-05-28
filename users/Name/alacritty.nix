{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
  colours = config.theming.colours;
  ansi = colours.ansi;

  font =
    if (config.theming.mainFont == "JetBrains Mono" && isDarwin) then
      "JetBrainsMono"
    else
      config.theming.mainFont;
in
{
  # Installs alacritty if we're on a Linux host
  programs.alacritty.enable = isLinux;

  xdg.configFile."alacritty.toml".text = ''
    [window]
    decorations = "None"
    opacity = ${lib.strings.floatToString config.theming.opacity}
    startup_mode = "Maximized"

    [font]
    normal = { family = "${font} NF" }
    size = 12

    [bell]
    duration = 250
    color = "${colours.secondaryAccent}"
    command = { program = "${pkgs.ffmpeg}/bin/ffplay", args = [ "-nodisp", "-autoexit", "${../../modules/misc/audio/bell.flac}", ] }

    [terminal]
    osc52 = "CopyPaste"

    # Terminal colours
    [colors]
    footer_bar = { foreground = "${colours.base}", background = "${colours.mainAccent}" }

    [colors.primary]
    foreground = "${colours.text}"
    background = "${colours.base}"

    [colors.search]
    matches = { foreground = "${colours.base}", background = "${colours.secondaryAccent}" }
    focused_match = { foreground = "${colours.base}", background = "${colours.mainAccent}" }

    [colors.hints]
    start = { foreground = "${colours.sapphire}", background = "CellBackground" }
    end = { foreground = "${colours.sapphire}", background = "CellBackground" }

    ## ANSI colours
    [colors.normal]
    black = "${ansi.black}"
    red = "${ansi.red}"
    green = "${ansi.green}"
    yellow = "${ansi.yellow}"
    blue = "${ansi.blue}"
    magenta = "${ansi.magenta}"
    cyan = "${ansi.cyan}"
    white = "${ansi.white}"

    [colors.bright]
    black = "${ansi.bright.black}"
    red = "${ansi.bright.red}"
    green = "${ansi.bright.green}"
    yellow = "${ansi.bright.yellow}"
    blue = "${ansi.bright.blue}"
    magenta = "${ansi.bright.magenta}"
    cyan = "${ansi.bright.cyan}"
    white = "${ansi.bright.white}"
  '';
}
