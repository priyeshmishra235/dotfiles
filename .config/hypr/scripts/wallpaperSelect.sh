#!/usr/bin/env bash
## /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##

# Wallpapers Path
wallpaperDir="$HOME/Pictures/wallpapers"
themesDir="$HOME/.config/rofi/themes"

# Transition config
FPS=60
TYPE="any"
DURATION=3
BEZIER="0.4,0.2,0.4,1.0"
SWWW_PARAMS="--transition-fps ${FPS} --transition-type ${TYPE} --transition-duration ${DURATION} --transition-bezier ${BEZIER}"

# Check if swaybg is running
if pidof swaybg > /dev/null; then
  pkill swaybg
fi

# Retrieve image files as a list
PICS=($(find -L "${wallpaperDir}" -type f \( -iname \*.jpg -o -iname \*.jpeg -o -iname \*.png \) | sort ))

# Use date variable to increase randomness
randomNumber=$(( ($(date +%s) + RANDOM) + $$ ))
randomPicture="${PICS[$(( randomNumber % ${#PICS[@]} ))]}"
randomChoice="[${#PICS[@]}] Random"

# Rofi command
rofiCommand="rofi -show -dmenu -theme ${themesDir}/wallpaper-select.rasi"

# Function to sync GTK theme with Pywal colors
update_gtk_theme() {
  local oomox_colors="$HOME/.cache/wal/colors-oomox"
  local theme_name="MyDynamicTheme"

  if [[ -f "$oomox_colors" ]]; then
    oomox-cli -t "$HOME/.themes" -o "$theme_name" "$oomox_colors"

    gsettings set org.gnome.desktop.interface gtk-theme "Adwaita"
    sleep 0.1
    gsettings set org.gnome.desktop.interface gtk-theme "$theme_name"
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
  else
    echo "Error: Oomox colors not found."
  fi
}

# genrate pywall and set wallpaper
executeCommand() {
  local img="$1"

  if command -v swww &>/dev/null; then
    swww img "$img" ${SWWW_PARAMS}
  elif command -v swaybg &>/dev/null; then
    killall swaybg
    swaybg -i "$img" &
  fi

  # set wallpaper
  ln -sf "$img" "$HOME/.current_wallpaper"

  # gen wal and gtk-theme
  if command -v wal &>/dev/null; then
    # basic python-pywal
    # wal -i "$img"
    # use colorthief for vibrant color palatte
    wal -i "$img" --backend colorthief
    # use haishoku for diverse color palatte
    # wal -i "$img" --backend haishoku
    update_gtk_theme
  fi

  # refresh ui
  if [[ -x "$HOME/.config/hypr/scripts/refresh.sh" ]]; then
    "$HOME/.config/hypr/scripts/refresh.sh" &
  fi
}

# Show the images
menu() {

  printf "$randomChoice\n"

  for i in "${!PICS[@]}"; do

    # If not *.gif, display
    if [[ -z $(echo "${PICS[$i]}" | grep .gif$) ]]; then
      printf "$(basename "${PICS[$i]}" | cut -d. -f1)\x00icon\x1f${PICS[$i]}\n"
    else
    # Displaying .gif to indicate animated images
      printf "$(basename "${PICS[$i]}")\n"
    fi
  done
}

# If swww exists, start it
if command -v swww &>/dev/null; then
  swww query || swww init
fi

# Execution
main() {
  choice=$(menu | ${rofiCommand})

  # No choice case
  if [[ -z $choice ]]; then
    exit 0
  fi

  # Random choice case
  if [ "$choice" = "$randomChoice" ]; then
    executeCommand "${randomPicture}"
    return 0
  fi

  # Find the selected file
  for file in "${PICS[@]}"; do
  # Getting the file
    if [[ "$(basename "$file" | cut -d. -f1)" = "$choice" ]]; then
      selectedFile="$file"
      break
    fi
  done

  # Check the file and execute
  if [[ -n "$selectedFile" ]]; then
    executeCommand "${selectedFile}"
    return 0
  else
    echo "Image not found."
    exit 1
  fi

}

# Check if rofi is already running
if pidof rofi > /dev/null; then
  pkill rofi
  exit 0
fi

main
