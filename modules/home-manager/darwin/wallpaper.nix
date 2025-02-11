{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  osascript = "/usr/bin/osascript";
in
{
  home.activation.set-wallpaper =
    assert lib.asserts.assertMsg (!builtins.pathExists osascript)
      "Apple has removed the osascript binary at ${osascript}. Changing wallpapers will not work without change.";
    lib.hm.dag.entryAfter [ "writeBoundary" ] (
      lib.optionalString isDarwin ''
        ${osascript} -e 'tell application "Finder"
          set desktop picture to POSIX file "${config.theming.wallpaper}"
        end tell'
      ''
    );
}
