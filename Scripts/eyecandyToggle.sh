#!/usr/bin/env bash

# Use a state file to track if Game Mode is ON or OFF
STATE_FILE="$HOME/.cache/gamemode_state"

# Check the current state of animations via hyprctl
HYPRGAMEMODE=$(hyprctl getoption animations:enabled | sed -n '1p' | awk '{print $2}')

if [ "$HYPRGAMEMODE" = 1 ]; then
    # --- TURN ON GAME MODE ---
    hyprctl -q --batch "\
        keyword animations:enabled 0;\
        keyword decoration:shadow:enabled 0;\
        keyword decoration:blur:enabled 0;\
        keyword general:gaps_in 0;\
        keyword general:gaps_out 0;\
        keyword general:border_size 1;\
        keyword decoration:rounding 0;\
        keyword decoration:active_opacity 1;\
        keyword decoration:inactive_opacity 1;\
        keyword layerrule noanim,waybar;\
        keyword layerrule noanim,swaync-notification-window;\
        keyword layerrule noanim,rofi"

    # Force all windows to be opaque
    hyprctl 'keyword windowrule opaque,class:(.*)'

    # Update state and notify
    touch "$STATE_FILE"
    notify-send -a "System" -i "input-gaming" -r 99 -u critical "Game Mode" "Performance Boost Active (FX Off)"
else
    hyprctl -q --batch "\
        keyword animations:enabled 1;\
        keyword decoration:shadow:enabled 1;\
        keyword decoration:blur:enabled 1;\
        keyword general:gaps_in 5;\
        keyword general:gaps_out 10;\
        keyword general:border_size 2;\
        keyword decoration:rounding 10;\
        keyword decoration:active_opacity 0.9;\
        keyword decoration:inactive_opacity 0.8;\
        keyword layerrule unset,waybar;\
        keyword layerrule unset,rofi"

    # Remove the global opaque rule
    hyprctl 'keyword windowrule " ",class:(.*)'

    # Cleanup state and notify
    rm -f "$STATE_FILE"
    notify-send -a "System" -i "video-display" -r 99 -u normal "Visual Mode" "Eye-Candy Restored (FX On)"
fi
