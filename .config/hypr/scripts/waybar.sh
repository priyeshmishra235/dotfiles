#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

WAYBAR_DIR="$HOME/.config/waybar"
ROFI_CONFIG="$HOME/.config/rofi/themes/selectorMenu.rasi"

THEMES_DIR="$WAYBAR_DIR/themes"
COLORS_DIR="$WAYBAR_DIR/colors"

CONFIG_TARGET="$WAYBAR_DIR/config"
STYLE_TARGET="$WAYBAR_DIR/style.css"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ╭──────────────────────────────────────────────────────────╮
# │                      Waybar restart                      │
# ╰──────────────────────────────────────────────────────────╯
restart_waybar() {
  if pgrep -x waybar >/dev/null; then
    pkill waybar
    sleep 0.1
  fi

  "$SCRIPT_DIR/refresh.sh" &
}

# ╭──────────────────────────────────────────────────────────╮
# │                   Rofi menu generator                    │
# ╰──────────────────────────────────────────────────────────╯
menu_from_dir() {
  local dir="$1"
  local ext="${2:-}"

  if [[ -n "$ext" ]]; then
    find "$dir" -maxdepth 1 -type f -name "*.$ext" |
      sort |
      xargs -I{} basename "{}" ".$ext"
  else
    find "$dir" -maxdepth 1 -type f |
      sort |
      xargs -I{} basename "{}"
  fi
}

# ╭──────────────────────────────────────────────────────────╮
# │                     Layout selector                      │
# ╰──────────────────────────────────────────────────────────╯
select_layout() {

  choice=$(menu_from_dir "$THEMES_DIR" |
    rofi -dmenu -config "$ROFI_CONFIG")

  [[ -z "$choice" ]] && exit 0

  if [[ "$choice" == "no panel" ]]; then
    pkill waybar || true
    exit 0
  fi

  ln -sf "$THEMES_DIR/$choice" "$CONFIG_TARGET"

  restart_waybar
}

# ╭──────────────────────────────────────────────────────────╮
# │                      Style selector                      │
# ╰──────────────────────────────────────────────────────────╯
select_style() {

  choice=$(menu_from_dir "$COLORS_DIR" css |
    rofi -dmenu -config "$ROFI_CONFIG")

  [[ -z "$choice" ]] && exit 0

  ln -sf "$COLORS_DIR/$choice.css" "$STYLE_TARGET"

  restart_waybar
}

# ╭──────────────────────────────────────────────────────────╮
# │                    Toggle rofi safety                    │
# ╰──────────────────────────────────────────────────────────╯
if pgrep -x rofi >/dev/null; then
  pkill rofi
  exit 0
fi

# ╭──────────────────────────────────────────────────────────╮
# │                      CLI dispatcher                      │
# ╰──────────────────────────────────────────────────────────╯
case "${1:-}" in
layout)
  select_layout
  ;;
style)
  select_style
  ;;
restart)
  restart_waybar
  ;;
*)
  echo "Usage:"
  echo "waybar.sh layout"
  echo "waybar.sh style"
  echo "waybar.sh restart"
  ;;
esac
