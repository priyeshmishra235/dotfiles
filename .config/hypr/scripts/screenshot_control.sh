#!/usr/bin/env bash

# ╭──────────────────────────────────────────────────────────╮
# │            Minimal Environment Initialization            │
# ╰──────────────────────────────────────────────────────────╯

export WAYLAND_DISPLAY=${WAYLAND_DISPLAY:-wayland-1}
export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-/run/user/$(id -u)}

GRIMBLAST_BIN="$HOME/dotfiles/.config/hypr/scripts/grimblast"

if [[ ! -x "$GRIMBLAST_BIN" ]]; then
    notify-send "Screenshot Error" "grimblast not executable or not found"
    exit 1
fi

# ╭──────────────────────────────────────────────────────────╮
# │                      Save Location                       │
# ╰──────────────────────────────────────────────────────────╯
instant_dir="$HOME/Pictures/Instant Screenshot"
screens_dir="$HOME/Pictures/Screenshots"

mkdir -p "$instant_dir" "$screens_dir"

# ╭──────────────────────────────────────────────────────────╮
# │              FullScreen Instant Screenshot               │
# ╰──────────────────────────────────────────────────────────╯
full_screen() {
    temp_screenshot=$(mktemp -t screenshot_XXXXXX.png)
    save_file="$(date +'%y%m%d_%Hh%Mm%Ss_screenshot.png')"
    save_path="$instant_dir/$save_file"

    if "$GRIMBLAST_BIN" copysave screen "$temp_screenshot"; then
        mv "$temp_screenshot" "$save_path"
        notify-send -a "Screenshot" -i "$save_path" "Saved to $instant_dir"
    else
        notify-send -a "Screenshot Error" "Failed to take screenshot"
        rm -f "$temp_screenshot"
        exit 1
    fi
}

# ╭──────────────────────────────────────────────────────────╮
# │                 Active Window Screenshot                 │
# ╰──────────────────────────────────────────────────────────╯
active_window() {
    temp_screenshot=$(mktemp -t screenshot_XXXXXX.png)
    save_file="$(date +'%y%m%d_%Hh%Mm%Ss_active_window.png')"
    save_path="$instant_dir/$save_file"

    if "$GRIMBLAST_BIN" copysave active "$temp_screenshot"; then
        mv "$temp_screenshot" "$save_path"
        notify-send -a "Screenshot" -i "$save_path" "Active window saved"
    else
        notify-send -a "Screenshot Error" "Failed to capture active window"
        rm -f "$temp_screenshot"
        exit 1
    fi
}

# ╭──────────────────────────────────────────────────────────╮
# │                  Area Select Screenshot                  │
# ╰──────────────────────────────────────────────────────────╯
area_select() {
    temp_screenshot=$(mktemp -t screenshot_XXXXXX.png)
    save_file="$(date +'%y%m%d_%Hh%Mm%Ss_screenshot.png')"
    save_path="$instant_dir/$save_file"

    if "$GRIMBLAST_BIN" copysave area "$temp_screenshot"; then
        mv "$temp_screenshot" "$save_path"
        notify-send -a "Screenshot" -i "$save_path" "Saved to $instant_dir"
    else
        notify-send -a "Screenshot Error" "Screenshot cancelled or failed"
        rm -f "$temp_screenshot"
        exit 1
    fi
}

# ╭──────────────────────────────────────────────────────────╮
# │                   Annotated Screenshot                   │
# ╰──────────────────────────────────────────────────────────╯
annotate() {
    temp="$XDG_RUNTIME_DIR/satty_tmp.png"
    save_file="$(date +'%Y-%m-%d_%H-%M-%S').png"
    save_path="$screens_dir/$save_file"

    grim "$temp"

    satty \
      --filename "$temp" \
      --output-filename "$save_path" \
      --copy-command "wl-copy"

    notify-send "Screenshot saved" "$save_path"
    rm -f "$temp"
}

case "$1" in
    full)       full_screen ;;
    active)     active_window ;;
    area)       area_select ;;
    annotate)   annotate ;;
    *)
        echo "Usage: screenshot_control.sh {full|active|area|annotate}"
        exit 1
        ;;
esac
