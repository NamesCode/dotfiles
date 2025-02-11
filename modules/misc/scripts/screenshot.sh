#!/usr/bin/env sh

DATE=$(date '+%Y-%m-%d')
FILENAME=$(printf "%s\nscreenshot\nclipboard\nquit\n" "$DATE" | tofi)
IMAGE_DIR=${XDG_PICTURES_DIR:-"$HOME/images"}

mkdir -p "$IMAGE_DIR"
mkdir -p "$IMAGE_DIR/screenshots"

if [ "$FILENAME" = "clipboard" ]; then
  grim -g "$(slurp -d)" - | wl-copy
elif [ "$FILENAME" != "quit" ] && [ "$FILENAME" != "" ]; then
  grim -g "$(slurp -d)" "$IMAGE_DIR/screenshots/$FILENAME.png"
fi
