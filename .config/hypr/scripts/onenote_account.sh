#!/usr/bin/env bash
set -e

PROFILE="$1"
APP_ID="com.patrikx3.onenote"

if [[ -z "$PROFILE" ]]; then
  echo "Usage: onenote_control.sh <profile_name>"
  exit 1
fi

# ╭──────────────────╮
# │ PERSONAL ONENOTE │
# ╰──────────────────╯
if [[ "$PROFILE" == "personal" ]]; then
  exec flatpak run "$APP_ID"
fi

# ╭──────────────────╮
# │ ISOLATED ONENOTE │
# ╰──────────────────╯
PROFILE_DIR="$HOME/.config/OneNote_${PROFILE}"
mkdir -p "$PROFILE_DIR"

exec flatpak run \
  --socket=x11 \
  --socket=session-bus \
  --socket=system-bus \
  --share=network \
  --share=ipc \
  --device=all \
  --env=ELECTRON_OZONE_PLATFORM_HINT=x11 \
  --filesystem="$PROFILE_DIR" \
  "$APP_ID" \
  --user-data-dir="$PROFILE_DIR" \
  --new-instance
