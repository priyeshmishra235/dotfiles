#!/usr/bin/env bash

if [[ "${HYDE_SHELL_INIT}" -ne 1 ]]; then
    eval "$(hyde-shell init)"
else
    export_hyde_config
fi

# === Full-Screen Screenshot Only ===

# Create temp file
temp_screenshot=$(mktemp -t screenshot_XXXXXX.png)

# Save directory
SAVE_DIR="$HOME/Pictures/Instant Screenshot"
mkdir -p "$SAVE_DIR"

# Save file name
SAVE_FILE="$(date +'%y%m%d_%Hh%Mm%Ss_screenshot.png')"
SAVE_PATH="$SAVE_DIR/$SAVE_FILE"

# Take screenshot (full screen only)
if "$LIB_DIR/hyde/grimblast" copysave screen "$temp_screenshot"; then
    mv "$temp_screenshot" "$SAVE_PATH"
    notify-send -a "Screenshot" -i "$SAVE_PATH" "Saved to $SAVE_DIR"
else
    notify-send -a "Screenshot Error" "Failed to take screenshot"
    rm -f "$temp_screenshot"
    exit 1
fi

exit 0
