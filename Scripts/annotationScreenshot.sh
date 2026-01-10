#!/usr/bin/env bash
set -e

export WAYLAND_DISPLAY=${WAYLAND_DISPLAY:-wayland-1}
export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-/run/user/$(id -u)}

TEMP="$XDG_RUNTIME_DIR/satty_tmp.png"
SAVE_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SAVE_DIR"

SAVE_FILE="$(date +'%Y-%m-%d_%H-%M-%S').png"
SAVE_PATH="$SAVE_DIR/$SAVE_FILE"

# 1) Capture screen
grim "$TEMP"

# 2) Tell Satty where Save should go
satty \
  --filename "$TEMP" \
  --output-filename "$SAVE_PATH" \
  --copy-command "wl-copy"

# 3) Notify
notify-send "Screenshot saved" "$SAVE_PATH"

rm -f "$TEMP"
