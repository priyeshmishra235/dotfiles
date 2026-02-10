#!/bin/bash
set -euo pipefail

GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m'

echo -e "${CYAN}[=] Arch Linux System Update & Cleanup Script${NC}"
echo -e "${YELLOW}$(date)${NC}\n"

echo -e "${YELLOW}Select an option:${NC}"
echo -e "1) ${GREEN}System Update${NC}"
echo -e "2) ${GREEN}System Cleanup${NC}"
echo -e "3) ${GREEN}Update then Cleanup${NC}"
echo -e "4) ${RED}Quit${NC}"
read -rp "Enter choice (1–4): " choice

CACHE_DIR="$HOME/.cache"
[[ -d "$CACHE_DIR" ]] || mkdir -p "$CACHE_DIR"

update_system() {
    echo -e "\n${CYAN}[>] Updating system packages...${NC}"
    sudo pacman -Syu --noconfirm || true
    if command -v paru &>/dev/null; then
        paru -Sua --noconfirm || true
    fi
}

cleanup_system() {
    echo -e "\n${CYAN}[>] Starting system cleanup...${NC}"

    echo -e "\n${GREEN}[*] Clearing stale pacman lock...${NC}"
    sudo rm -f /var/lib/pacman/db.lck || true

    echo -e "\n${GREEN}[*] Removing orphaned packages...${NC}"
    orphans="$(pacman -Qdtq 2>/dev/null || true)"
    [[ -n "$orphans" ]] && sudo pacman -Rns $orphans --noconfirm || echo -e "${YELLOW}[!] No orphaned packages found.${NC}"

    echo -e "\n${GREEN}[*] Removing broken / invalid local packages...${NC}"
    broken_pkgs="$(pacman -Qk 2>/dev/null | awk '/warning:/{print $1}' | sort -u || true)"
    [[ -n "$broken_pkgs" ]] && sudo pacman -Rns $broken_pkgs --noconfirm || echo -e "${YELLOW}[!] No broken local packages found.${NC}"

    echo -e "\n${GREEN}[*] Cleaning pacman cache...${NC}"
    sudo paccache -rk3 || true
    sudo paccache -ruk0 || true

    echo -e "\n${GREEN}[*] Removing incomplete pacman downloads...${NC}"
    sudo find /var/cache/pacman/pkg -name '*.part' -delete || true
    sudo find /var/cache/pacman/pkg -name 'download-*' -delete || true

    echo -e "\n${GREEN}[*] Refreshing pacman databases...${NC}"
    sudo pacman -Syy --noconfirm || true

    echo -e "\n${GREEN}[*] Cleaning paru cache and failed builds...${NC}"
    if command -v paru &>/dev/null; then
        paru -Scd --noconfirm || true
        rm -rf ~/.cache/paru/{clone,build} || true
        find ~/.cache/paru -type d -empty -delete || true
    fi

    if command -v yay &>/dev/null; then
        yay -Scd --noconfirm --answerclean All --answerdiff None || true
    fi

    echo -e "\n${GREEN}[*] Cleaning selected user caches (non-destructive)...${NC}"
    rm -rf ~/.cache/yay ~/.cache/npm ~/.cache/pip ~/.cache/pipenv ~/.cache/meson ~/.cache/CMakeFiles ~/.cache/go-build ~/.cargo/registry ~/.cargo/git 2>/dev/null || true
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

case "$choice" in
    1) update_system ;;
    2) cleanup_system ;;
    3) update_system; cleanup_system ;;
    4) echo -e "\n${CYAN}[=] Exiting. No changes made.${NC}"; exit 0 ;;
    *) echo -e "\n${RED}[!] Invalid choice.${NC}"; exit 1 ;;
esac
