#!/usr/bin/env bash
#
# acer_sense_ctl.sh
# Control LinuwuSense / Predator / Nitro VFS for thermal, fan, keyboard, battery, etc.
#
# Usage examples:
#   ./acer_sense_ctl.sh status
#   ./acer_sense_ctl.sh set-fan 50,70
#   ./acer_sense_ctl.sh set-backlight-timeout 1
#   ./acer_sense_ctl.sh set-platform-profile balanced      # Nitro/AC profile
#   ./acer_sense_ctl.sh set-per-zone 4287f5,ff5733,33ff57,ff33a6,100
#   ./acer_sense_ctl.sh interactive
#
# Must be run on a machine with /sys mounted and the module present.
# Writes are performed via "sudo tee" so you'll be prompted for password when needed.
#

set -euo pipefail
IFS=$'\n\t'

# ---------- Config / detection ----------
PREDATOR_PATH="/sys/module/linuwu_sense/drivers/platform:acer-wmi/acer-wmi/predator_sense"
NITRO_PATH="/sys/module/linuwu_sense/drivers/platform:acer-wmi/acer-wmi/nitro_sense"
FOUR_ZONE_BASE="/sys/module/linuwu_sense/drivers/platform:acer-wmi/acer-wmi/four_zoned_kb"

# Allow override with env var
BASE_PATH="${ACER_SENSE_PATH:-}"
if [[ -z "$BASE_PATH" ]]; then
  if [[ -d "$PREDATOR_PATH" ]]; then
    BASE_PATH="$PREDATOR_PATH"
  elif [[ -d "$NITRO_PATH" ]]; then
    BASE_PATH="$NITRO_PATH"
  else
    BASE_PATH=""
  fi
fi

# Helper: path exists?
file_exists() {
  local f="$1"
  [[ -e "$f" ]]
}

# Helper: write to vfs safely using sudo tee
vfs_write() {
  local target="$1"
  local value="$2"
  if [[ ! -w "$target" && ! -e "$target" ]]; then
    echo "ERROR: target $target does not exist or is not writable."
    return 1
  fi
  # Use sudo tee so that redirection permission issues are avoided
  echo -n "$value" | sudo tee "$target" > /dev/null
}

vfs_read() {
  local target="$1"
  if ! file_exists "$target"; then
    echo "N/A"
    return 1
  fi
  cat "$target" 2>/dev/null || echo "ERR"
}

ensure_base() {
  if [[ -z "$BASE_PATH" ]]; then
    echo "ERROR: Could not find Predato r/Nitro sense path. Set ACER_SENSE_PATH env var to override."
    exit 1
  fi
}

# ---------- Feature functions ----------

# 0. platform_profile (Nitro): read / set
PLATFORM_PROFILE_PATH="/sys/firmware/acpi/platform_profile"
PLATFORM_CHOICES_PATH="/sys/firmware/acpi/platform_profile_choices"

get_platform_profile() {
  if file_exists "$PLATFORM_PROFILE_PATH"; then
    cat "$PLATFORM_PROFILE_PATH"
  else
    echo "N/A"
  fi
}

get_platform_choices() {
  if file_exists "$PLATFORM_CHOICES_PATH"; then
    cat "$PLATFORM_CHOICES_PATH"
  else
    echo "N/A"
  fi
}

set_platform_profile() {
  local profile="$1"
  if ! file_exists "$PLATFORM_PROFILE_PATH"; then
    echo "Platform profile interface not present on this machine."
    return 1
  fi
  # optional validation against choices
  if file_exists "$PLATFORM_CHOICES_PATH"; then
    local choices
    choices="$(tr ' ' '\n' < "$PLATFORM_CHOICES_PATH")"
    if ! grep -qw "$profile" <<<"$choices"; then
      echo "Warning: '$profile' not in supported choices: $(cat "$PLATFORM_CHOICES_PATH")"
    fi
  fi
  echo "$profile" | sudo tee "$PLATFORM_PROFILE_PATH" > /dev/null
  echo "Set platform profile -> $profile"
}

# 1. Backlight timeout (0/1)
backlight_timeout_path() { echo "$BASE_PATH/backlight_timeout"; }
get_backlight_timeout() { vfs_read "$(backlight_timeout_path)"; }
set_backlight_timeout() {
  local v="$1"
  if [[ "$v" != "0" && "$v" != "1" ]]; then
    echo "Invalid backlight_timeout value. Use 0 or 1."
    return 1
  fi
  vfs_write "$(backlight_timeout_path)" "$v"
  echo "backlight_timeout -> $v"
}

# 2. Battery calibration (0/1)
battery_calibration_path() { echo "$BASE_PATH/battery_calibration"; }
get_battery_calibration() { vfs_read "$(battery_calibration_path)"; }
set_battery_calibration() {
  local v="$1"
  if [[ "$v" != "0" && "$v" != "1" ]]; then
    echo "Invalid battery_calibration value. Use 0 or 1."
    return 1
  fi
  vfs_write "$(battery_calibration_path)" "$v"
  echo "battery_calibration -> $v"
}

# 3. Battery limiter (0/1)
battery_limiter_path() { echo "$BASE_PATH/battery_limiter"; }
get_battery_limiter() { vfs_read "$(battery_limiter_path)"; }
set_battery_limiter() {
  local v="$1"
  if [[ "$v" != "0" && "$v" != "1" ]]; then
    echo "Invalid battery_limiter value. Use 0 or 1."
    return 1
  fi
  vfs_write "$(battery_limiter_path)" "$v"
  echo "battery_limiter -> $v"
}

# 4. Boot animation sound (0/1)
boot_animation_sound_path() { echo "$BASE_PATH/boot_animation_sound"; }
get_boot_animation_sound() { vfs_read "$(boot_animation_sound_path)"; }
set_boot_animation_sound() {
  local v="$1"
  if [[ "$v" != "0" && "$v" != "1" ]]; then
    echo "Invalid boot_animation_sound value. Use 0 or 1."
    return 1
  fi
  vfs_write "$(boot_animation_sound_path)" "$v"
  echo "boot_animation_sound -> $v"
}

# 5. Fan speed (format: CPU, GPU) numeric 0-100 (0 = auto)
fan_speed_path() { echo "$BASE_PATH/fan_speed"; }
get_fan_speed() { vfs_read "$(fan_speed_path)"; }
set_fan_speed() {
  local pair="$1"
  # allow "auto" or "0" or "num,num"
  if [[ "$pair" == "auto" ]]; then
    vfs_write "$(fan_speed_path)" "0"
    echo "fan_speed -> auto"
    return 0
  fi
  if ! [[ "$pair" =~ ^[0-9]{1,3},[0-9]{1,3}$ ]]; then
    echo "Invalid fan format. Use 'cpu,gpu' with values 0-100 (0=auto). Example: 50,70"
    return 1
  fi
  IFS=',' read -r a b <<<"$pair"
  if (( a < 0 || a > 100 || b < 0 || b > 100 )); then
    echo "Fan values must be between 0 and 100."
    return 1
  fi
  vfs_write "$(fan_speed_path)" "$a,$b"
  echo "fan_speed -> $a,$b"
}

# 6. LCD override (0/1)
lcd_override_path() { echo "$BASE_PATH/lcd_override"; }
get_lcd_override() { vfs_read "$(lcd_override_path)"; }
set_lcd_override() {
  local v="$1"
  if [[ "$v" != "0" && "$v" != "1" ]]; then
    echo "Invalid lcd_override value. Use 0 or 1."
    return 1
  fi
  vfs_write "$(lcd_override_path)" "$v"
  echo "lcd_override -> $v"
}

# 7. USB charging (0/10/20/30)
usb_charging_path() { echo "$BASE_PATH/usb_charging"; }
get_usb_charging() { vfs_read "$(usb_charging_path)"; }
set_usb_charging() {
  local v="$1"
  if ! [[ "$v" =~ ^(0|10|20|30)$ ]]; then
    echo "Invalid usb_charging value. Use one of: 0,10,20,30"
    return 1
  fi
  vfs_write "$(usb_charging_path)" "$v"
  echo "usb_charging -> $v"
}

# Keyboard: per_zone_mode (hex RRGGBB x4, brightness)
per_zone_path() { echo "$FOUR_ZONE_BASE/per_zone_mode"; }
get_per_zone_mode() { vfs_read "$(per_zone_path)"; }
validate_hex_color() {
  local c="$1"
  if [[ "$c" =~ ^[0-9a-fA-F]{6}$ ]]; then
    return 0
  fi
  return 1
}
set_per_zone_mode() {
  local payload="$1"
  # Expect 5 items: hex,hex,hex,hex,brightness
  IFS=',' read -r c1 c2 c3 c4 br <<<"$payload" || true
  if [[ -z "$br" || -z "$c4" || -z "$c3" || -z "$c2" || -z "$c1" ]]; then
    echo "Invalid per_zone payload. Expected: hex,hex,hex,hex,brightness"
    echo "Example: 4287f5,ff5733,33ff57,ff33a6,100"
    return 1
  fi
  for c in "$c1" "$c2" "$c3" "$c4"; do
    if ! validate_hex_color "$c"; then
      echo "Invalid hex color: $c. Must be 6 hex digits RRGGBB."
      return 1
    fi
  done
  if ! [[ "$br" =~ ^[0-9]{1,3}$ ]] || (( br < 0 || br > 100 )); then
    echo "Brightness must be 0-100."
    return 1
  fi
  vfs_write "$(per_zone_path)" "$c1,$c2,$c3,$c4,$br"
  echo "per_zone_mode -> $c1,$c2,$c3,$c4,$br"
}

# Keyboard: four_zone_mode (7 params: mode(0-7), speed(0-9), brightness(0-100), direction(1-2), R(0-255), G(0-255), B(0-255))
four_zone_path() { echo "$FOUR_ZONE_BASE/four_zone_mode"; }
get_four_zone_mode() { vfs_read "$(four_zone_path)"; }
set_four_zone_mode() {
  local payload="$1"
  IFS=',' read -r mode speed bright dir r g b <<<"$payload" || true
  if [[ -z "$b" ]]; then
    echo "Invalid four_zone payload. Expected: mode(0-7),speed(0-9),brightness(0-100),direction(1-2),R,G,B"
    echo "Example: 3,1,100,2,0,0,0"
    return 1
  fi
  if ! [[ "$mode" =~ ^[0-7]$ ]]; then echo "mode 0-7"; return 1; fi
  if ! [[ "$speed" =~ ^[0-9]$ ]]; then echo "speed 0-9"; return 1; fi
  if ! [[ "$bright" =~ ^[0-9]{1,3}$ ]] || (( bright < 0 || bright > 100 )); then echo "brightness 0-100"; return 1; fi
  if ! [[ "$dir" =~ ^[12]$ ]]; then echo "direction 1 or 2"; return 1; fi
  for val in "$r" "$g" "$b"; do
    if ! [[ "$val" =~ ^[0-9]{1,3}$ ]] || (( val < 0 || val > 255 )); then echo "RGB each 0-255"; return 1; fi
  done
  vfs_write "$(four_zone_path)" "$mode,$speed,$bright,$dir,$r,$g,$b"
  echo "four_zone_mode -> $mode,$speed,$bright,$dir,$r,$g,$b"
}

# ---------- Helpers: power source detection ----------
# Try common AC-online paths, fallback to battery detection
is_plugged_ac() {
  # check common AC path(s)
  # Try /sys/class/power_supply/AC/online or ACAD or AC0
  for p in /sys/class/power_supply/AC/online /sys/class/power_supply/ACAD/online /sys/class/power_supply/AC0/online /sys/class/power_supply/ADP1/online; do
    if [[ -r "$p" ]]; then
      local v
      v=$(cat "$p" 2>/dev/null || echo "0")
      if [[ "$v" == "1" ]]; then
        return 0
      else
        return 1
      fi
    fi
  done
  # fallback: check battery status
  for b in /sys/class/power_supply/BAT0/status /sys/class/power_supply/BAT1/status; do
    if [[ -r "$b" ]]; then
      local s
      s=$(cat "$b")
      if [[ "$s" =~ Charging|Full ]]; then
        return 0
      else
        return 1
      fi
    fi
  done
  # unknown -> assume AC
  return 0
}

# ---------- Status summary ----------
status() {
  ensure_base
  echo "Detected base path: $BASE_PATH"
  echo "Platform profile: $(get_platform_profile)    (choices: $(get_platform_choices) )"
  echo
  echo "Backlight timeout: $(get_backlight_timeout)"
  echo "Battery calibration: $(get_battery_calibration)"
  echo "Battery limiter: $(get_battery_limiter)"
  echo "Boot animation sound: $(get_boot_animation_sound)"
  echo "Fan speed (cpu,gpu): $(get_fan_speed)"
  echo "LCD override: $(get_lcd_override)"
  echo "USB charging: $(get_usb_charging)"
  echo
  if [[ -d "$FOUR_ZONE_BASE" ]]; then
    echo "Per-zone keyboard: $(get_per_zone_mode)"
    echo "Four-zone mode: $(get_four_zone_mode)"
  else
    echo "Keyboard four_zoned_kb not present."
  fi
  echo
  if is_plugged_ac; then
    echo "Power source: AC (plugged in)"
  else
    echo "Power source: Battery"
  fi
}

# ---------- Interactive menu ----------
interactive_menu() {
  ensure_base
  while true; do
    echo "----------------------------------------"
    echo "Acer Sense Control - Interactive Menu"
    echo "Base path: $BASE_PATH"
    echo "1) Status summary"
    echo "2) Set platform profile (Nitro)"
    echo "3) Toggle backlight timeout (0/1)"
    echo "4) Battery calibration (0/1)"
    echo "5) Battery limiter (0/1)"
    echo "6) Boot animation sound (0/1)"
    echo "7) Set fan speed (cpu,gpu) or 'auto'"
    echo "8) LCD override (0/1)"
    echo "9) USB charging (0/10/20/30)"
    echo "10) Set keyboard per-zone (hex,hex,hex,hex,brightness)"
    echo "11) Set keyboard four-zone mode (mode,speed,brightness,dir,R,G,B)"
    echo "q) Quit"
    printf "Choose: "
    read -r choice
    case "$choice" in
      1) status ;;
      2)
         echo "Choices: $(get_platform_choices)"
         read -rp "Profile> " pr
         set_platform_profile "$pr" || true
         ;;
      3)
         read -rp "backlight_timeout (0/1)> " v
         set_backlight_timeout "$v" || true
         ;;
      4)
         read -rp "battery_calibration (0/1)> " v
         set_battery_calibration "$v" || true
         ;;
      5)
         read -rp "battery_limiter (0/1)> " v
         set_battery_limiter "$v" || true
         ;;
      6)
         read -rp "boot_animation_sound (0/1)> " v
         set_boot_animation_sound "$v" || true
         ;;
      7)
         read -rp "fan (cpu,gpu) or 'auto'> " v
         set_fan_speed "$v" || true
         ;;
      8)
         read -rp "lcd_override (0/1)> " v
         set_lcd_override "$v" || true
         ;;
      9)
         read -rp "usb_charging (0/10/20/30)> " v
         set_usb_charging "$v" || true
         ;;
      10)
         echo "Example: 4287f5,ff5733,33ff57,ff33a6,100"
         read -rp "per_zone payload> " v
         set_per_zone_mode "$v" || true
         ;;
      11)
         echo "Example: 3,1,100,2,0,0,0"
         read -rp "four_zone payload> " v
         set_four_zone_mode "$v" || true
         ;;
      q|Q) echo "Bye."; break ;;
      *) echo "Invalid choice." ;;
    esac
  done
}

# ---------- CLI routing ----------
show_help() {
  cat <<EOF
Usage: $0 <command> [args...]

Commands:
  status
  interactive

  # Nitro platform profile
  get-platform-profile
  set-platform-profile <name>

  # Backlight
  get-backlight-timeout
  set-backlight-timeout <0|1>

  # Battery calibration
  get-battery-calibration
  set-battery-calibration <0|1>

  # Battery limiter
  get-battery-limiter
  set-battery-limiter <0|1>

  # Boot sound
  get-boot-animation-sound
  set-boot-animation-sound <0|1>

  # Fan speed
  get-fan-speed
  set-fan <cpu,gpu|auto>

  # LCD override
  get-lcd-override
  set-lcd-override <0|1>

  # USB charging
  get-usb-charging
  set-usb-charging <0|10|20|30>

  # Keyboard
  get-per-zone
  set-per-zone <hex,hex,hex,hex,brightness>
  get-four-zone
  set-four-zone <mode,speed,brightness,dir,R,G,B>

Examples:
  $0 status
  $0 set-fan 50,70
  $0 set-per-zone 4287f5,4287f5,4287f5,4287f5,100
  $0 set-platform-profile balanced

Note: writes use sudo tee; you'll be prompted for password when needed.
EOF
}

# ---------- Main ----------
cmd="${1:-help}"
shift 2>/dev/null || true

case "$cmd" in
  status) status ;;
  interactive) interactive_menu ;;
  get-platform-profile) get_platform_profile ;;
  set-platform-profile) set_platform_profile "$1" ;;
  get-backlight-timeout) ensure_base; get_backlight_timeout ;;
  set-backlight-timeout) ensure_base; set_backlight_timeout "$1" ;;
  get-battery-calibration) ensure_base; get_battery_calibration ;;
  set-battery-calibration) ensure_base; set_battery_calibration "$1" ;;
  get-battery-limiter) ensure_base; get_battery_limiter ;;
  set-battery-limiter) ensure_base; set_battery_limiter "$1" ;;
  get-boot-animation-sound) ensure_base; get_boot_animation_sound ;;
  set-boot-animation-sound) ensure_base; set_boot_animation_sound "$1" ;;
  get-fan-speed) ensure_base; get_fan_speed ;;
  set-fan) ensure_base; set_fan_speed "$1" ;;
  get-lcd-override) ensure_base; get_lcd_override ;;
  set-lcd-override) ensure_base; set_lcd_override "$1" ;;
  get-usb-charging) ensure_base; get_usb_charging ;;
  set-usb-charging) ensure_base; set_usb_charging "$1" ;;
  get-per-zone) ensure_base; get_per_zone_mode ;;
  set-per-zone) ensure_base; set_per_zone_mode "$1" ;;
  get-four-zone) ensure_base; get_four_zone_mode ;;
  set-four-zone) ensure_base; set_four_zone_mode "$1" ;;
  help|-h|--help) show_help ;;
  *) echo "Unknown command: $cmd"; show_help; exit 2 ;;
esac

exit 0
