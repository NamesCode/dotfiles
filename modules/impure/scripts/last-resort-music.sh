#!/usr/bin/env sh

MUSIC_DIR=${XDG_MUSIC_DIR:-$(pwd)}

printf "Couldn't find the album, huh? What's the URL of the music video?: "
read URL

printf "What would you like to save it as? (auto suffixed by .ogg): "
read FILENAME

nix run nixpkgs#yt-dlp -- -x --audio-format opus -o "$MUSIC_DIR/$FILENAME" "$URL" > /dev/null
mv "$MUSIC_DIR/$FILENAME.opus" "$MUSIC_DIR/$FILENAME.ogg" 
printf "Successfully ripped and saved too $MUSIC_DIR/$FILENAME.ogg! :3"
