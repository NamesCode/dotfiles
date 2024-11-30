#!/usr/bin/env sh

DATE=$(date '+%Y-%m-%d')
FILENAME=$(printf "%s\nscreenshot\nclipboard\nquit\n" "$DATE" | tofi)


if [ "$FILENAME" == "clipboard" ]; then
  grim -g "$(slurp -d)" - | wl-copy
elif [ "$FILENAME" != "quit" ] && [ "$FILENAME" != "" ]; then
  grim -g "$(slurp -d)" "$FILENAME.png"
fi
