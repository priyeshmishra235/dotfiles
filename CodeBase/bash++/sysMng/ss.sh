#!/bin/bash

# Save directory
SAVE_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SAVE_DIR"

# Find the next available serial number
next_index=$(find "$SAVE_DIR" -maxdepth 1 -type f -name '[0-9]*.png' \
    | sed -E 's/.*\/([0-9]+)\.png/\1/' \
    | sort -n \
    | tail -n 1)

if [[ -z "$next_index" ]]; then
    next_index=1
else
    next_index=$((next_index + 1))
fi

# Filename
FILENAME="${next_index}.png"
FILEPATH="${SAVE_DIR}/${FILENAME}"

# Choose mode
case "$1" in
    full)
        grim "$FILEPATH"
        ;;
    area)
        grim -g "$(slurp)" "$FILEPATH"
        ;;
    copy)
        grim -g "$(slurp)" - | wl-copy
        notify-send "Screenshot copied to clipboard"
        exit 0
        ;;
    *)
        echo "Usage: $0 {full|area|copy}"
        exit 1
        ;;
esac

# Notification
notify-send "Screenshot saved" "$FILENAME"
