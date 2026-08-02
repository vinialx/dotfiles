#!/usr/bin/env bash

CHOSEN=$(cliphist list | sed '1i Clean History' | rofi -dmenu -p 'Clipboard' -theme ~/.config/rofi/theme.rasi)

if [ "$CHOSEN" = "Clean History" ]; then
  cliphist wipe
  exit 0
fi

echo "$CHOSEN" | cliphist decode | wl-copy
