#!/usr/bin/env bash

# ╭──────────────────────────────────────────────────────────╮
# │                 HYPRLOCK THEME SELECTOR                  │
# ╰──────────────────────────────────────────────────────────╯

set -euo pipefail

LOCK_DIR="$HOME/.config/hypr/hyprlock"
TARGET_FILE="$HOME/.config/hypr/hyprlock.conf"
ROFI_CONFIG="$HOME/.config/rofi/themes/selectorMenu.rasi"

menu() {
    find "$LOCK_DIR" -maxdepth 1 -type f -name '*.conf' -printf "%f\n" | \
    sed 's/\.conf$//' | \
    sort
}

apply_lock() {
    local choice="$1"
    ln -sf "$LOCK_DIR/$choice.conf" "$TARGET_FILE"
}

if pgrep -x "rofi" >/dev/null; then
    pkill rofi
    exit 0
fi

choice=$(menu | rofi -dmenu -p "Hyprlock" -config "$ROFI_CONFIG")

if [[ -n "$choice" ]]; then
    apply_lock "$choice"
fi

exit 0
