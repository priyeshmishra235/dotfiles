#!/usr/bin/env bash

exists() {
  command -v "$1" >/dev/null 2>&1
}

total_updates=0

echo "Checking for available package updates..."
echo

# PACMAN
pacman_updates=0
if exists pacman; then
  pacman_updates=$(pacman -Qu 2>/dev/null | wc -l)
  total_updates=$((total_updates + pacman_updates))
fi

# AUR
aur_updates=0
if exists yay; then
  aur_updates=$(yay -Qua 2>/dev/null | wc -l)
elif exists paru; then
  aur_updates=$(paru -Qua 2>/dev/null | wc -l)
fi
total_updates=$((total_updates + aur_updates))

# Flatpak
flatpak_updates=0
if exists flatpak; then
  flatpak_updates=$(flatpak remote-ls --updates 2>/dev/null | wc -l)
  total_updates=$((total_updates + flatpak_updates))
fi

# Snap
snap_updates=0
if exists snap; then
  snap_updates=$(snap refresh --list 2>/dev/null | wc -l)
  total_updates=$((total_updates + snap_updates))
fi

# No updates
if [ "$total_updates" -eq 0 ]; then
  echo "System is up to date."
  echo
  read -p "Press Enter to close..."
  exit 0
fi

echo "Updates available:"
echo "  pacman  : $pacman_updates"
echo "  aur     : $aur_updates"
echo "  flatpak : $flatpak_updates"
echo "  snap    : $snap_updates"
echo "----------------------------------"
echo "Total updates: $total_updates"
echo

read -p "Proceed with updating all package managers? (y/N): " confirm

if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
  echo "Aborted."
  exit 0
fi

# UPDATE PHASE
[ "$pacman_updates" -gt 0 ] && sudo pacman -Syu
[ "$aur_updates" -gt 0 ] && {
  exists yay && yay -Syu
  exists paru && paru -Syu
}
[ "$flatpak_updates" -gt 0 ] && flatpak update -y
[ "$snap_updates" -gt 0 ] && sudo snap refresh

echo "Packages Updated"
