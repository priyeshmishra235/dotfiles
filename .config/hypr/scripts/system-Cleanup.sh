#!/bin/bash
set -euo pipefail

GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m'

echo -e "${CYAN}[=] Arch Linux System Cleanup Script${NC}"
echo -e "${YELLOW}$(date)${NC}\n"

cleanup_system() {
  echo -e "\n${CYAN}[>] Starting system cleanup...${NC}"

  echo -e "\n${GREEN}[*] Clearing stale pacman lock...${NC}"
  sudo rm -f /var/lib/pacman/db.lck || true

  echo -e "\n${GREEN}[*] Removing orphaned packages...${NC}"
  orphans="$(pacman -Qdtq 2>/dev/null || true)"
  if [[ -n "$orphans" ]]; then
    sudo pacman -Rns $orphans --noconfirm
  else
    echo -e "${YELLOW}[!] No orphaned packages found.${NC}"
  fi

  echo -e "\n${GREEN}[*] Removing broken / invalid local packages...${NC}"
  broken_pkgs="$(pacman -Qk 2>/dev/null | awk '/warning:/{print $1}' | sort -u || true)"
  if [[ -n "$broken_pkgs" ]]; then
    sudo pacman -Rns $broken_pkgs --noconfirm
  else
    echo -e "${YELLOW}[!] No broken local packages found.${NC}"
  fi

  echo -e "\n${GREEN}[*] Cleaning pacman cache...${NC}"
  sudo paccache -rk3 || true
  sudo paccache -ruk0 || true

  echo -e "\n${GREEN}[*] Removing incomplete pacman downloads...${NC}"
  sudo find /var/cache/pacman/pkg -name '*.part' -delete || true
  sudo find /var/cache/pacman/pkg -name 'download-*' -delete || true

  if command -v paru &>/dev/null; then
    echo -e "\n${GREEN}[*] Cleaning paru cache...${NC}"
    paru -Scd --noconfirm || true
    rm -rf ~/.cache/paru/{clone,build} || true
    find ~/.cache/paru -type d -empty -delete || true
  fi

  if command -v yay &>/dev/null; then
    echo -e "\n${GREEN}[*] Cleaning yay cache...${NC}"
    yay -Scd --noconfirm --answerclean All --answerdiff None || true
  fi

  echo -e "\n${GREEN}[*] Cleaning selected user caches...${NC}"
  rm -rf ~/.cache/yay ~/.cache/npm ~/.cache/pip ~/.cache/pipenv \
    ~/.cache/meson ~/.cache/CMakeFiles ~/.cache/go-build \
    ~/.cargo/registry ~/.cargo/git 2>/dev/null || true
  find ~/.cache -type f -atime +14 -delete || true

  echo -e "\n${GREEN}[*] Cleaning temp directories...${NC}"
  sudo rm -rf /tmp/* /var/tmp/* || true

  echo -e "\n${GREEN}[*] Vacuuming journal logs...${NC}"
  sudo journalctl --vacuum-size=100M || true

  echo -e "\n${GREEN}[*] Purging core dumps...${NC}"
  sudo rm -rf /var/lib/systemd/coredump/* || true

  echo -e "\n${GREEN}[*] Rebuilding font cache...${NC}"
  rm -rf ~/.cache/fontconfig || true
  sudo rm -rf /var/cache/fontconfig/* || true
  fc-cache -r || true

  echo -e "\n${GREEN}[*] pacnew / pacsave files:${NC}"
  sudo find /etc -type f \( -name "*.pacnew" -o -name "*.pacsave" \) || true

  if command -v flatpak &>/dev/null; then
    echo -e "\n${GREEN}[*] Cleaning Flatpak...${NC}"
    flatpak uninstall --unused -y || true
    rm -rf ~/.cache/flatpak ~/.var/app/*/cache || true
    sudo rm -rf /var/cache/flatpak/* || true
  fi

  if command -v snap &>/dev/null; then
    echo -e "\n${GREEN}[*] Cleaning Snap...${NC}"
    snap list --all | awk '/disabled/{print $1, $3}' | while read -r name rev; do
      sudo snap remove --purge "$name" --revision="$rev" -y
    done
    sudo rm -rf /var/lib/snapd/cache/* || true
  fi

  echo -e "\n${CYAN}[+] System cleanup completed successfully.${NC}"
}

cleanup_system
