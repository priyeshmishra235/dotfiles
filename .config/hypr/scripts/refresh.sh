#!/usr/bin/env bash

# Kill already running processes
_ps=(waybar rofi swaync)
for _prs in "${_ps[@]}"; do
  if pidof "${_prs}" >/dev/null; then
    pkill "${_prs}"
  fi
done

sleep 0.1
# Relaunch waybar
waybar >/dev/null 2>&1 &

# relaunch swaync
sleep 0.k
swaync >/dev/null 2>&1 &

exit 0
