#!/usr/bin/env bash

wallpaperDir="$HOME/Pictures/wallpapers"
themesDir="$HOME/.config/rofi/themes"
thumbCache="$HOME/.cache/wallpaper_thumbs"

FOLDER_ICON="$HOME/.config/rofi/icons/folder.png"
RANDOM_ICON="$HOME/.config/rofi/icons/dice.png"

mkdir -p "$thumbCache"

FPS=60
TYPE="any"
DURATION=3
BEZIER="0.4,0.2,0.4,1.0"
SWWW_PARAMS="--transition-fps ${FPS} --transition-type ${TYPE} --transition-duration ${DURATION} --transition-bezier ${BEZIER}"

rofiCommand="rofi -dmenu -hover-select -theme ${themesDir}/wallpaper-select.rasi"

get_thumb() {
  local img="$1"
  local hash
  hash=$(printf "%s" "$img" | sha1sum | awk '{print $1}')
  printf "%s/%s.png" "$thumbCache" "$hash"
}

get_folder_icon() {
  local dir="$1"
  local src="${dir}/.icon.png"
  local hash
  hash=$(printf "%s" "$dir" | sha1sum | awk '{print $1}')
  local cached="${thumbCache}/folder_${hash}.png"

  if [[ ! -f "$cached" ]]; then
    if [[ -f "$src" ]]; then
      magick "$src" -thumbnail 128x128 -strip "$cached" 2>/dev/null
    else
      magick "$FOLDER_ICON" -thumbnail 128x128 -strip "$cached" 2>/dev/null
    fi
  fi

  printf "%s" "$cached"
}

get_static_icon() {
  local src="$1"
  local name="$2"
  local cached="${thumbCache}/${name}.png"

  if [[ ! -f "$cached" ]]; then
    magick "$src" -thumbnail 128x128 -strip "$cached" 2>/dev/null
  fi

  printf "%s" "$cached"
}
update_gtk_theme() {
  local oomox_colors="$HOME/.cache/wal/colors-oomox"
  local theme_name="MyDynamicTheme"

  if [[ -f "$oomox_colors" ]]; then
    # 1. Build the theme with GTK3.20+ optimizations
    oomox-cli "$oomox_colors" -o "$theme_name" -t "$HOME/.themes" -m gtk320 >/dev/null 2>&1

    # 2. Sync GTK4/Libadwaita (The "Light Mode" Killer)
    mkdir -p "$HOME/.config/gtk-4.0"
    ln -sf "$HOME/.cache/wal/colors-gtk.css" "$HOME/.config/gtk-4.0/gtk.css"

    # 3. Apply and Refresh
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    gsettings set org.gnome.desktop.interface gtk-theme "Adwaita"
    sleep 0.2
    gsettings set org.gnome.desktop.interface gtk-theme "$theme_name"
  fi
}
generate_palette_async() {
  (
    wal -i "$1" --backend colorthief >/dev/null 2>&1
    update_gtk_theme
  ) &
}

categories() {

  rand_icon=$(get_static_icon "$RANDOM_ICON" "dice")
  printf "%s\x00icon\x1f%s\n" "[Random]" "$rand_icon"

  mapfile -t dirs < <(
    find "$wallpaperDir" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort
  )

  for d in "${dirs[@]}"; do
    icon=$(get_folder_icon "${wallpaperDir}/${d}")
    printf "%s\x00icon\x1f%s\n" "$d" "$icon"
  done
}

list_images() {
  local dir="$1"

  printf "[Random]\x00icon\x1f%s\n" "$RANDOM_ICON"

  find -L "$dir" -maxdepth 1 -type f \
    \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) \
    -print0 | sort -z |
    while IFS= read -r -d '' file; do
      thumb=$(get_thumb "$file")
      name=$(basename "$file")
      printf "%s\x00icon\x1f%s\n" "${name%.*}" "$thumb"
    done
}

execute_wallpaper() {
  local img="$1"

  swww img "$img" ${SWWW_PARAMS}
  ln -sf "$img" "$HOME/.current_wallpaper"

  generate_palette_async "$img"
}

command -v swww >/dev/null && swww query || swww init

selection=$(categories | rofi -dmenu -p "Categories" -theme "${themesDir}/wallpaper-select.rasi")
[[ -z "$selection" ]] && exit 0

if [[ "$selection" == "[Random]" ]]; then
  mapfile -d '' ALL < <(find "$wallpaperDir" -type f -print0)
  execute_wallpaper "${ALL[RANDOM % ${#ALL[@]}]}"
  exit 0
fi

fullPath="${wallpaperDir}/${selection}"

choice=$(list_images "$fullPath" | ${rofiCommand} -p "$selection")
[[ -z "$choice" ]] && exit 0

if [[ "$choice" == "[Random]" ]]; then
  mapfile -d '' CATEGORY < <(find "$fullPath" -type f -print0)
  execute_wallpaper "${CATEGORY[RANDOM % ${#CATEGORY[@]}]}"
  exit 0
fi

while IFS= read -r -d '' file; do
  name="${file##*/}"
  name="${name%.*}"
  if [[ "$name" == "$choice" ]]; then
    execute_wallpaper "$file"
    break
  fi
done < <(find "$fullPath" -type f -print0)
