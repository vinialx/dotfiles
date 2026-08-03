#!/usr/bin/env bash
set -uo pipefail

FONT=$(cat /home/vinicius/dotfiles/fonts/main.txt)
ICON_FONT=$(cat /home/vinicius/dotfiles/fonts/icons.txt)

[ -f ~/.config/waybar/style.css ] && sed -i "0,/font-family: \"[^\"]*\";/s//font-family: \"$FONT\";/" ~/.config/waybar/style.css
[ -f ~/.config/swaync/style.css ] && sed -i "0,/font-family: \"[^\"]*\";/s//font-family: \"$FONT\";/" ~/.config/swaync/style.css
[ -f ~/.config/ghostty/config ] && sed -i "s/font-family = .*/font-family = $FONT/" ~/.config/ghostty/config
[ -f ~/.config/rofi/theme.rasi ] && sed -i "s/font: \"[^\"]*\";/font: \"$FONT 13\";/g" ~/.config/rofi/theme.rasi
[ -f ~/.config/orbit/style.css ] && sed -i "0,/font-family: \"[^\"]*\";/s//font-family: \"$FONT\";/" ~/.config/orbit/style.css

echo "Fonte de texto aplicada: $FONT"
echo "Fonte de ícones definida: $ICON_FONT"
