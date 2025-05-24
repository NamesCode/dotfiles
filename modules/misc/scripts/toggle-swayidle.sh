#!/bin/sh

# TODO: Make macOS version

PID=$(pgrep -x swayidle)

if [ -n "$PID" ]; then
  kill -s TERM "$PID"
else
  swayidle timeout 120 'swaylock -f' timeout 240 'systemctl suspend' before-sleep 'swaylock -f' lock 'swaylock -f'
fi
