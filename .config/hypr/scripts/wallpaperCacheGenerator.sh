#!/usr/bin/env bash

wallpaperDir="$HOME/Pictures/wallpapers"
thumbCache="$HOME/.cache/wallpaper_thumbs"

mkdir -p "$thumbCache"

build_thumb() {
  img="$1"
  hash=$(printf "%s" "$img" | sha1sum | awk '{print $1}')
  thumb="${thumbCache}/${hash}.png"

  [[ -f "$thumb" ]] && return

  magick "$img" \
    -define jpeg:size=512x512 \
    -thumbnail 256x256 \
    -strip \
    "$thumb" 2>/dev/null
}

export -f build_thumb
export thumbCache

find "$wallpaperDir" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) -print0 |
  xargs -0 -P 8 -n 1 bash -c 'build_thumb "$0"'
