#!/bin/bash

set -euo pipefail

# === CONFIG ===
USER_HOME="/home/priyeshmishra"
REPO="/run/media/priyeshmishra/Medusa/borg-home"
NOW=$(date +%Y-%m-%d--%H-%M)
ARCHIVE="home-$NOW"

# === CHECK: is backup drive mounted? ===
if ! mountpoint -q "$(dirname "$REPO")"; then
  echo "[!] Backup drive is not mounted at $(dirname "$REPO"). Aborting."
fi

# === Backup Command ===
echo "[*] Starting borg backup at $NOW..."

borg create \
  --verbose --stats --show-rc --list --filter AME \
  --compression zstd,6 \
  "$REPO::$ARCHIVE" \
  "$USER_HOME" \
  --exclude "$USER_HOME/Clone" \
  --exclude "$USER_HOME/Obsidian" \
  --exclude "$USER_HOME/borg-home-KEY-Passphrase" \
  --exclude "$USER_HOME/Desktop" \
  --exclude "$USER_HOME/Documents" \
  --exclude "$USER_HOME/Downloads" \
  --exclude "$USER_HOME/go" \
  --exclude "$USER_HOME/home" \
  --exclude "$USER_HOME/HyDE" \
  --exclude "$USER_HOME/Music" \
  --exclude "$USER_HOME/Pictures" \
  --exclude "$USER_HOME/Public" \
  --exclude "$USER_HOME/Templates" \
  --exclude "$USER_HOME/Videos" \
  --exclude "$USER_HOME/.dotnet" \
  --exclude "$USER_HOME/.cache" \
  --exclude "$USER_HOME/.icons" \
  --exclude "$USER_HOME/.npm" \
  --exclude "$USER_HOME/.parallel"

# === Prune old backups ===
echo "[*] Pruning old backups..."
borg prune -v --list "$REPO" \
  --keep-daily=7 \
  --keep-weekly=4 \
  --keep-monthly=6

echo "[✓] Backup complete at $(date)"

# [[

## Initialize the repository (1st encryption only, then backup script):
# borg init --encryption repokey /run/media/priyeshmishra/Aris/borg-home

## After initallizing borg repository save the KEY to safe place(does not have passphrase saved)
## Need to save passphrase separately
## Save KEY in all these three format
# borg key export /run/media/priyeshmishra/Aris/borg-home ~/Documents/borg-key
# borg key export --paper /run/media/priyeshmishra/Aris/borg-home ~/Documents/borg-key.txt
# borg key export --qr-html /run/media/priyeshmishra/Aris/borg-home ~/Documents/borg-key.html

## To delete complete borg repository
# borg delete --verbose /run/media/priyeshmishra/Aris/borg-home

# ]]
