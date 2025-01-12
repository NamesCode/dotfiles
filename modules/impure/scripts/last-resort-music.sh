#!/usr/bin/env sh

MUSIC_DIR=${XDG_MUSIC_DIR:-$(pwd)}

mkdir -p MUSIC_DIR

printf "Couldn't find the album, huh? What's the URL of the music video?: "
read -r URL

printf "What would you like to save it as? (auto suffixed by .ogg): "
read -r FILENAME

nix run nixpkgs#yt-dlp -- -x --audio-format opus -o "$MUSIC_DIR/$FILENAME" "$URL" > /dev/null
mv "$MUSIC_DIR/$FILENAME.opus" "$MUSIC_DIR/$FILENAME.ogg" 
printf "Successfully ripped and saved too %s/%s.ogg! :3" "$MUSIC_DIR" "$FILENAME"
