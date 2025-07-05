#!/bin/bash

# === Arch Linux Update & Cleanup Script ===

# --- Colors ---
GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m' # No Color

# --- Start ---
echo -e "${CYAN}[=] Arch Linux System Update & Cleanup Script${NC}"
echo -e "${YELLOW}$(date)${NC}\n"

# --- User Choice ---
echo -e "${YELLOW}Please select an option:${NC}"
echo -e "1) ${GREEN}System Update${NC}"
echo -e "2) ${GREEN}System Cleanup${NC}"
echo -e "3) ${GREEN}Update then Cleanup${NC}"
echo -e "4) ${RED}Quit${NC}"
read -p "Enter choice (1, 2, 3, or 4): " choice

# --- Functions ---

update_system() {
    echo -e "\n${CYAN}[>] Starting System Update...${NC}"
    sudo pacman -Syu --noconfirm
}

cleanup_system() {
    echo -e "\n${CYAN}[>] Starting System Cleanup...${NC}"

    echo -e "${GREEN}[*] Removing orphaned packages...${NC}"
    orphans=$(pacman -Qdtq)
    if [[ -n "$orphans" ]]; then
        sudo pacman -Rns $orphans --noconfirm
    else
        echo -e "${YELLOW}[!] No orphaned packages found.${NC}"
    fi

    echo -e "\n${GREEN}[*] Cleaning pacman cache (keeping latest 3 versions)...${NC}"
    sudo paccache -rk3

    echo -e "\n${GREEN}[*] Cleaning AUR helper cache...${NC}"
    if command -v yay &>/dev/null; then
        yay -Sc --noconfirm
    else
        echo -e "${YELLOW}[!] AUR helper 'yay' not installed. Skipping AUR cache cleanup.${NC}"
    fi

    echo -e "\n${GREEN}[*] Removing broken .part downloads...${NC}"
    sudo find /var/cache/pacman/pkg/ -name '*.part' -type f -delete

    echo -e "\n${GREEN}[*] Cleaning ~/.cache...${NC}"
    find ~/.cache -mindepth 1 -delete

    echo -e "\n${GREEN}[*] Vacuuming journal logs to 100MB...${NC}"
    sudo journalctl --vacuum-size=100M

    echo -e "\n${GREEN}[*] Searching for .pacnew / .pacsave files...${NC}"
    sudo find /etc -type f \( -name "*.pacnew" -o -name "*.pacsave" \) 2>/dev/null

    echo -e "\n${GREEN}[*] Installed kernel-related packages...${NC}"
    pacman -Q | grep -E '^linux'

    echo -e "\n${CYAN}[+] System Cleanup completed successfully!${NC}"
}

# --- Main ---

case "$choice" in
    1)
        update_system
        echo -e "\n${CYAN}[+] System Update completed successfully!${NC}"
        ;;
    2)
        cleanup_system
        ;;
    3)
        update_system
        cleanup_system
        echo -e "\n${CYAN}[+] System Update and Cleanup completed successfully!${NC}"
        ;;
    4)
        echo -e "\n${CYAN}[=] Exiting script. No changes made.${NC}"
        exit 0
        ;;
    *)
        echo -e "\n${RED}[!] Invalid choice. Please choose 1, 2, 3, or 4.${NC}"
        ;;
esac
