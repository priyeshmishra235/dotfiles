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
        keyword decoration:blur:xray 1;\
        keyword general:gaps_in 0;\
        keyword general:gaps_out 0;\
        keyword general:border_size 1;\
        keyword misc:vfr true;\
        keyword decoration:rounding 0;\
        keyword decoration:active_opacity 1;\
        keyword decoration:inactive_opacity 1;\
        keyword decoration:fullscreen_opacity 1;\
        keyword layerrule noanim true;\
        keyword layerrule blur false;\
        keyword layerrule noanim,waybar;\
        keyword layerrule noanim,swaync-notification-window;\
        keyword layerrule noanim,rofi"

  # Force all windows to be opaque
  hyprctl 'keyword windowrule opaque,class:(.*)'

  # Update state and notify
  touch "$STATE_FILE"
  notify-send -a "System" -i "input-gaming" -r 99 -u critical "Game Mode" "Performance Boost Active (FX Off)"
else
  hyprctl reload

  # Remove the global opaque rule
  # hyprctl 'keyword windowrule " ",class:(.*)'

  # Cleanup state and notify
  rm -f "$STATE_FILE"
  notify-send -a "System" -i "video-display" -r 99 -u normal "Visual Mode" "Eye-Candy Restored (FX On)"
fi
