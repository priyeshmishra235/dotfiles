#!/usr/bin/env bash

wallpaperDir="$HOME/Pictures/wallpapers"
thumbCache="$HOME/.cache/wallpaper_thumbs"

mkdir -p "$thumbCache"

build_thumb() {
  img="$1"
  hash=$(printf "%s" "$img" | sha1sum | awk '{print $1}')
  thumb="${thumbCache}/${hash}.png"

  [[ -f "$thumb" ]] && exit 0

  magick "$img" \
    -define jpeg:size=512x512 \
    -thumbnail 256x256 \
    -strip \
    "$thumb" 2>/dev/null
}

export -f build_thumb
export thumbCache

find "$wallpaperDir" -type f \
  \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.webp" -o -iname "*.avif" -o -iname "*.png" \) -print0 |
  parallel -0 -j"$(nproc)" build_thumb
