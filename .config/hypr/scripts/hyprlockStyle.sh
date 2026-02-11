#!/usr/bin/env bash

set -euo pipefail

LOCK_DIR="$HOME/.config/hypr/hyprlock"
TARGET_FILE="$HOME/.config/hypr/hyprlock.conf"
ROFI_CONFIG="$HOME/.config/rofi/themes/selectorMenu.rasi"
FONT_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/fonts"

install_font() {
    local name="$1"
    local url="$2"

    if ! fc-list : family | grep -qi "$name"; then
        temp_dir=$(mktemp -d)
        if curl -s -L "$url" -o "$temp_dir/font.zip"; then
            mkdir -p "$FONT_DIR/$name"
            unzip -qoj "$temp_dir/font.zip" -d "$FONT_DIR/$name" "*.ttf" "*.otf" 2>/dev/null || true
            fc-cache -f "$FONT_DIR"
        fi
        rm -rf "$temp_dir"
    fi
}

menu() {
    find "$LOCK_DIR" -maxdepth 1 -type f -name '*.conf' -printf "%f\n" | sed 's/\.conf$//' | sort
}

apply_lock() {
    local choice="$1"
    local config_path="$LOCK_DIR/$choice.conf"

    ln -sf "$config_path" "$TARGET_FILE"

    if data=$(grep -Eo '^\s*\$resolve\.font\s*=\s*[^|]+\s*\|\s*[^ ]+' "$config_path"); then
        font_name=$(echo "$data" | awk -F'=' '{print $2}' | awk -F'|' '{print $1}' | xargs)
        font_url=$(echo "$data" | awk -F'|' '{print $2}' | xargs)
        install_font "$font_name" "$font_url"
    fi
}

if pgrep -x "rofi" >/dev/null; then
    pkill rofi
    exit 0
fi

choice=$(menu | rofi -dmenu -p "Hyprlock" -config "$ROFI_CONFIG")

if [[ -n "$choice" ]]; then
    apply_lock "$choice"
fi
