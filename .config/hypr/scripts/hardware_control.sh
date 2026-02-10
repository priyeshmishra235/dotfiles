#!/usr/bin/env sh

# ╭──────────────────────────────────────────────────────────╮
# │                      AUDIO CONTROL                       │
# ╰──────────────────────────────────────────────────────────╯
SINK='@DEFAULT_AUDIO_SINK@'
SOURCE='@DEFAULT_AUDIO_SOURCE@'
SYNC='string:x-canonical-private-synchronous:sys-notify'

notify_volume() {
  vol=$(wpctl get-volume "$SINK" | awk '{print int($2*100)}')
  notify-send -u low -h int:value:"$vol" -h "$SYNC" "Volume"
}

toggle_sink_mute() {
  wpctl set-mute "$SINK" toggle
  if wpctl get-volume "$SINK" | grep -q MUTED; then
    notify-send -u low -h "$SYNC" "Audio" "Muted"
  else
    notify-send -u low -h "$SYNC" "Audio" "Unmuted"
  fi
}

toggle_source_mute() {
  wpctl set-mute "$SOURCE" toggle
  if wpctl get-volume "$SOURCE" | grep -q MUTED; then
    notify-send -u low -h "$SYNC" "Microphone" "Muted"
  else
    notify-send -u low -h "$SYNC" "Microphone" "Unmuted"
  fi
}

# ╭──────────────────────────────────────────────────────────╮
# │                    BRIGHTNESS CONTROL                    │
# ╰──────────────────────────────────────────────────────────╯
BRIGHT_SYNC='string:x-canonical-private-synchronous:sys-notify'

notify_brightness() {
  val=$(brightnessctl i | grep -oP '\(\K[^%]+')
  notify-send -u low -h int:value:"$val" -h "$BRIGHT_SYNC" "Brightness"
}

brightness_up() {
  brightnessctl set 1%+
  notify_brightness
}

brightness_down() {
  brightnessctl set 1%-
  notify_brightness
}

# ╭──────────────────────────────────────────────────────────╮
# │                           MENU                           │
# ╰──────────────────────────────────────────────────────────╯
case "$1" in
  mute)        toggle_sink_mute ;;
  micmute)     toggle_source_mute ;;
  volup)       wpctl set-volume "$SINK" 5%+; notify_volume ;;
  voldown)     wpctl set-volume "$SINK" 5%-; notify_volume ;;
  brightup)    brightness_up ;;
  brightdown)  brightness_down ;;
  *)
    echo "Usage: hardware_control.sh {mute|micmute|volup|voldown|brightup|brightdown}"
    exit 1
    ;;
esac
