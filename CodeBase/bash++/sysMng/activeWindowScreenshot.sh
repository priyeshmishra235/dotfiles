#!/usr/bin/env bash

if [[ "${HYDE_SHELL_INIT}" -ne 1 ]]; then
    eval "$(hyde-shell init)"
else
    export_hyde_config
fi

# === Active Window Screenshot ===

temp_screenshot=$(mktemp -t screenshot_XXXXXX.png)

SAVE_DIR="$HOME/Pictures/Instant Screenshot"
mkdir -p "$SAVE_DIR"

SAVE_FILE="$(date +'%y%m%d_%Hh%Mm%Ss_active_window.png')"
SAVE_PATH="$SAVE_DIR/$SAVE_FILE"

if "$LIB_DIR/hyde/grimblast" copysave active "$temp_screenshot"; then
    mv "$temp_screenshot" "$SAVE_PATH"
    notify-send -a "Screenshot" -i "$SAVE_PATH" "Active window saved"
else
    notify-send -a "Screenshot Error" "Failed to capture active window"
    rm -f "$temp_screenshot"
    exit 1
fi

exit 0
