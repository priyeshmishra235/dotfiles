#!/usr/bin/env bash

font_dir="${XDG_DATA_HOME:-$HOME/.local/share}/fonts"
temp_base="${XDG_CACHE_HOME:-$HOME/.cache}/font_installer"

mkdir -p "$font_dir" "$temp_base"

download_and_extract() {
  local name="$1"
  local url="$2"
  local temp_dir="$temp_base/$name"

  domain=${url#*://}
  domain=${domain%%/*}
  if ! ping -c 1 "$domain" &>/dev/null; then
    echo "[font] Network error: Cannot reach $domain"
    return 1
  fi

  echo "[font] Downloading $name..."
  mkdir -p "$temp_dir"

  if ! curl -s -L "$url" -o "$temp_dir/archive_file"; then
    echo "[font] Failed to download $name"
    return 1
  fi

  mime_type=$(file --mime-type -b "$temp_dir/archive_file")

  case "$mime_type" in
  application/zip)
    unzip -qoj "$temp_dir/archive_file" -d "$font_dir/$name" "*.ttf" "*.otf" 2>/dev/null
    ;;
  application/x-tar | application/x-gzip | application/x-xz)
    mkdir -p "$font_dir/$name"
    tar -xf "$temp_dir/archive_file" -C "$font_dir/$name" --strip-components=1 2>/dev/null
    ;;
  *)
    if [[ "$url" == *.ttf ]] || [[ "$url" == *.otf ]]; then
      mv "$temp_dir/archive_file" "$font_dir/$name.${url##*.}"
    else
      echo "[font] Unsupported file format for $name"
      return 1
    fi
    ;;
  esac

  rm -rf "$temp_dir"
  fc-cache -f "$font_dir"
  echo "[font] $name installed successfully."
  notify-send -i "preferences-desktop-font" "Font Installer" "$name installed successfully"
}

resolve() {
  local config_file="$1"

  if [[ ! -f "$config_file" ]]; then
    echo "[font] Config file not found: $config_file"
    return 1
  fi

  grep -Eo '^\s*\$resolve\.font\s*=\s*[^|]+\s*\|\s*[^ ]+' "$config_file" | while IFS='=' read -r _ data; do
    name=$(echo "$data" | awk -F'|' '{print $1}' | xargs)
    url=$(echo "$data" | awk -F'|' '{print $2}' | xargs)

    # Check if font is already installed
    if ! fc-list : family | grep -qi "$name"; then
      download_and_extract "$name" "$url"
    else
      echo "[font] $name is already installed."
    fi
  done
}

if [[ "$1" == "resolve" ]]; then
  resolve "$2"
else
  "$@"
fi
