#!/usr/bin/env bash

set -euo pipefail

ANIM_DIR="$HOME/.config/hypr/animations"
TARGET_FILE="$HOME/.config/hypr/configs/animations.conf"
ROFI_CONFIG="$HOME/.config/rofi/themes/selectorMenu.rasi"

menu() {
  find "$ANIM_DIR" -maxdepth 1 -type f -name '*.conf' -not -name 'animations.conf' |
    xargs -n1 basename |
    sed 's/\.conf$//' |
    sort
}

apply_anim() {
  local choice=$1
  ln -sf "$ANIM_DIR/$choice.conf" "$TARGET_FILE"

  hyprctl reload >/dev/null 2>&1
}

if pgrep -x "rofi" >/dev/null; then
  pkill rofi
  exit 0
fi

choice=$(menu | rofi -dmenu -p "Animations" -config "$ROFI_CONFIG")

if [[ -n "$choice" ]]; then
  apply_anim "$choice"
fi

exit 0
