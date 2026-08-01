#!/usr/bin/env bash
set -euo pipefail

WALLPAPER_DIR="/home/vinicius/dotfiles/wallpapers/"

WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | shuf -n 1)

if [ -z "$WALLPAPER" ]; then
  exit 1
fi

awww img "$WALLPAPER" --transition-type wipe --transition-fps 60 --transition-duration 1.5

matugen image "$WALLPAPER" --source-color-index 0
