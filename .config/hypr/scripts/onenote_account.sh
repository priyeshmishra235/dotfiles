#!/usr/bin/env bash
set -e

PROFILE="$1"
BINARY="/usr/bin/p3x-onenote"

if [[ -z "$PROFILE" ]]; then
  echo "Usage: onenote_control.sh <profile_name>"
  exit 1
fi

if [[ "$PROFILE" == "personal" ]]; then
  PROFILE_DIR="$HOME/electron/OneNote"
else
  PROFILE_DIR="$HOME/electron/OneNote_${PROFILE}"
fi

mkdir -p "$PROFILE_DIR"

exec "$BINARY" --user-data-dir="$PROFILE_DIR" --new-instance
