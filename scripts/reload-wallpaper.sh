#!/usr/bin/env bash
set -euo pipefail

WALLPAPER_DIR="/home/vinicius/dotfiles/wallpapers/"
VIDEO_DIR="/home/vinicius/dotfiles/wallpapers/live"

ALL_FILES=$(
  find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) 2>/dev/null
  find "$VIDEO_DIR" -type f \( -iname "*.mp4" -o -iname "*.webm" -o -iname "*.mkv" \) 2>/dev/null
)

CHOSEN=$(echo "$ALL_FILES" | shuf -n 1)
EXT="${CHOSEN##*.}"

pkill mpvpaper 2>/dev/null || true

case "$EXT" in
mp4 | webm | mkv)
  FRAME="/tmp/wallpaper-frame.png"
  ffmpeg -y -ss 00:00:03 -i "$CHOSEN" -frames:v 1 "$FRAME" -loglevel quiet
  matugen image "$FRAME" --source-color-index 0
  mpvpaper -o "no-audio loop" '*' "$CHOSEN" &
  ;;
jpg | jpeg | png)
  awww img "$CHOSEN" --transition-type wipe --transition-fps 60 --transition-duration 1.5
  matugen image "$CHOSEN" --source-color-index 0
  ;;
esac

notify-send "Wallpaper" "Changed to $(basename "$CHOSEN")"
