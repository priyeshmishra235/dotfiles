#!/usr/bin/env bash

set -euo pipefail

LOCK_DIR="$HOME/.config/hypr/hyprlock"
TARGET_FILE="$HOME/.config/hypr/hyprlock.conf"
ROFI_CONFIG="$HOME/.config/rofi/themes/selectorMenu.rasi"

FONT_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/fonts"
TEMP_BASE="${XDG_CACHE_HOME:-$HOME/.cache}/font_installer"

mkdir -p "$FONT_DIR" "$TEMP_BASE"

notify() {
  notify-send -i "preferences-desktop-font" "Hyprlock Theme" "$1"
}
# ╭──────────────────────────────────────────────────────────╮
# │                font download and extract                 │
# ╰──────────────────────────────────────────────────────────╯

download_and_extract() {

  local name="$1"
  local url="$2"
  local temp_dir="$TEMP_BASE/$name"

  notify "Installing font: $name"

  domain=${url#*://}
  domain=${domain%%/*}

  if ! ping -c 1 "$domain" &>/dev/null; then
    notify "Network error contacting $domain"
    return 1
  fi

  mkdir -p "$temp_dir"

  if ! curl -sL "$url" -o "$temp_dir/archive_file"; then
    notify "Download failed for $name"
    return 1
  fi

  mime_type=$(file --mime-type -b "$temp_dir/archive_file")

  case "$mime_type" in
  application/zip)
    unzip -qoj "$temp_dir/archive_file" -d "$FONT_DIR/$name" "*.ttf" "*.otf" 2>/dev/null
    ;;
  application/x-tar | application/x-gzip | application/x-xz)
    mkdir -p "$FONT_DIR/$name"
    tar -xf "$temp_dir/archive_file" -C "$FONT_DIR/$name" --strip-components=1 2>/dev/null
    ;;
  *)
    if [[ "$url" == *.ttf ]] || [[ "$url" == *.otf ]]; then
      mv "$temp_dir/archive_file" "$FONT_DIR/$name.${url##*.}"
    else
      notify "Unsupported archive format for $name"
      return 1
    fi
    ;;
  esac

  rm -rf "$temp_dir"

  fc-cache -f "$FONT_DIR"

  notify "$name installed successfully"
}

# ╭──────────────────────────────────────────────────────────╮
# │           font dependency and existence check            │
# ╰──────────────────────────────────────────────────────────╯

resolve_fonts() {

  local config_file="$1"

  [[ ! -f "$config_file" ]] && return

  notify "Checking theme font dependencies"

  while IFS='=' read -r key value; do

    [[ "$key" =~ \$resolve\.font ]] || continue

    name="$(printf "%s" "$value" | cut -d'|' -f1 | xargs)"
    url="$(printf "%s" "$value" | cut -d'|' -f2- | xargs)"

    [[ -z "$name" || -z "$url" ]] && continue

    if fc-list : family | grep -qi "$name"; then
      notify "$name already installed"
    else
      download_and_extract "$name" "$url"
    fi

  done <"$config_file"
}

# ╭──────────────────────────────────────────────────────────╮
# │                    data for generator                    │
# ╰──────────────────────────────────────────────────────────╯
menu() {
  find "$LOCK_DIR" -maxdepth 1 -type f -name '*.conf' \
    -printf "%f\n" | sed 's/\.conf$//' | sort
}

# ╭──────────────────────────────────────────────────────────╮
# │                Apply selected lockscreen                 │
# ╰──────────────────────────────────────────────────────────╯
apply_lock() {

  local choice="$1"
  local config_path="$LOCK_DIR/$choice.conf"

  ln -sf "$config_path" "$TARGET_FILE"

  resolve_fonts "$config_path" &

  notify "Hyprlock theme applied: $choice"
}

# ╭──────────────────────────────────────────────────────────╮
# │                  Hyplock style selector                  │
# ╰──────────────────────────────────────────────────────────╯
select_style() {

  if pgrep -x rofi >/dev/null; then
    pkill rofi
    exit 0
  fi

  choice=$(menu | rofi -dmenu -p "Hyprlock" -config "$ROFI_CONFIG")

  if [[ -n "$choice" ]]; then
    apply_lock "$choice"
  fi
}

# ╭──────────────────────────────────────────────────────────╮
# │                   launch the hyprlock                    │
# ╰──────────────────────────────────────────────────────────╯
launch_lock() {

  if pgrep -x hyprlock >/dev/null; then
    exit 0
  fi

  hyprlock
}

# ╭──────────────────────────────────────────────────────────╮
# │                       CLI commands                       │
# ╰──────────────────────────────────────────────────────────╯
case "${1:-style}" in

style)
  select_style
  ;;

launch)
  launch_lock
  ;;

*)
  echo "Usage:"
  echo "  hyprlock.sh style"
  echo "  hyprlock.sh launch"
  ;;

esac
