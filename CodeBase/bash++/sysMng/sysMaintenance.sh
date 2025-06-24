#!/bin/bash

# === Arch Linux Update & Cleanup Script ===

# --- Colors ---
GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m' # No Color

# --- Start ---
echo -e "${CYAN}🔧 Arch Linux System Update & Cleanup Script${NC}"
echo -e "${YELLOW}$(date)${NC}\n"

# --- User Choice ---
echo -e "${YELLOW}Please select an option:${NC}"
echo -e "1) ${GREEN}System Update${NC}"
echo -e "2) ${GREEN}System Cleanup${NC}"
echo -e "3) ${GREEN}Update then Cleanup${NC}"
echo -e "4) ${RED}Quit${NC}"
read -p "Enter choice (1, 2, 3, or 4): " choice

# --- System Update ---
if [[ "$choice" -eq 1 ]]; then
    echo -e "\n${CYAN}🔄 Starting System Update...${NC}"

    # Step 1: Update System (Pacman)
    echo -e "${GREEN}Updating package databases and upgrading packages...${NC}"
    sudo pacman -Syu --noconfirm

    # Step 2: Update Hyprland (if needed)
    echo -e "${GREEN}Updating Hyprland...${NC}"
    sudo pacman -S hyprland --noconfirm

    # Final step: Update any other necessary dependencies and packages
    echo -e "${GREEN}Running an additional package update check...${NC}"
    sudo pacman -Qdt

    # Success message
    echo -e "\n${CYAN}✅ System Update completed successfully!${NC}"

# --- System Cleanup ---
elif [[ "$choice" -eq 2 ]]; then
    echo -e "\n${CYAN}🧹 Starting System Cleanup...${NC}"

    # --- Orphaned Packages ---
    echo -e "${GREEN}🔍 Removing orphaned packages...${NC}"
    orphans=$(pacman -Qdtq)
    if [[ -n "$orphans" ]]; then
        sudo pacman -Rns $orphans --noconfirm
    else
        echo -e "${YELLOW}No orphaned packages found.${NC}"
    fi

    # --- Pacman Cache ---
    echo -e "\n${GREEN}🧹 Cleaning pacman cache (keep latest 3 versions)...${NC}"
    sudo paccache -r --noconfirm

    # --- AUR Helper Cache (yay) ---
    echo -e "\n${GREEN}🧨 Cleaning AUR helper cache...${NC}"
    if command -v yay &>/dev/null; then
        yay -Sc --noconfirm
    else
        echo -e "${YELLOW}AUR helper 'yay' not installed. Skipping AUR cache cleanup.${NC}"
    fi

    # --- User Cache ---
    echo -e "\n${GREEN}📂 Cleaning ~/.cache...${NC}"
    rm -rf ~/.cache/*
    mkdir -p ~/.cache

    # --- Journal Logs ---
    echo -e "\n${GREEN}📝 Vacuuming journal logs to 100MB...${NC}"
    sudo journalctl --vacuum-size=100M

    # --- Config File Checks ---
    echo -e "\n${GREEN}⚙️ Searching for .pacnew / .pacsave files...${NC}"
    sudo find /etc -type f \( -name "*.pacnew" -o -name "*.pacsave" \) 2>/dev/null

    # --- Kernel Packages ---
    echo -e "\n${GREEN}🐧 Installed kernel-related packages...${NC}"
    sudo pacman -Q | grep -E '^linux'

    # Success message
    echo -e "\n${CYAN}✅ System Cleanup completed successfully!${NC}"

# --- Update then Cleanup ---
elif [[ "$choice" -eq 3 ]]; then
    echo -e "\n${CYAN}🔄 Starting System Update followed by Cleanup...${NC}"

    # --- Step 1: Update System ---
    echo -e "${GREEN}Updating system...${NC}"
    sudo pacman -Syu --noconfirm
    sudo pacman -S hyprland --noconfirm
    sudo pacman -Qdt

    # --- Step 2: Cleanup ---
    echo -e "\n${CYAN}🧹 Starting System Cleanup...${NC}"

    # --- Orphaned Packages ---
    echo -e "${GREEN}🔍 Removing orphaned packages...${NC}"
    orphans=$(pacman -Qdtq)
    if [[ -n "$orphans" ]]; then
        sudo pacman -Rns $orphans --noconfirm
    else
        echo -e "${YELLOW}No orphaned packages found.${NC}"
    fi

    # --- Pacman Cache ---
    echo -e "\n${GREEN}🧹 Cleaning pacman cache (keep latest 3 versions)...${NC}"
    sudo paccache -r --noconfirm

    # --- AUR Helper Cache (yay) ---
    echo -e "\n${GREEN}🧨 Cleaning AUR helper cache...${NC}"
    if command -v yay &>/dev/null; then
        yay -Sc --noconfirm
    else
        echo -e "${YELLOW}AUR helper 'yay' not installed. Skipping AUR cache cleanup.${NC}"
    fi

    # --- User Cache ---
    echo -e "\n${GREEN}📂 Cleaning ~/.cache...${NC}"
    rm -rf ~/.cache/*
    mkdir -p ~/.cache

    # --- Journal Logs ---
    echo -e "\n${GREEN}📝 Vacuuming journal logs to 100MB...${NC}"
    sudo journalctl --vacuum-size=100M

    # --- Config File Checks ---
    echo -e "\n${GREEN}⚙️ Searching for .pacnew / .pacsave files...${NC}"
    sudo find /etc -type f \( -name "*.pacnew" -o -name "*.pacsave" \) 2>/dev/null

    # --- Kernel Packages ---
    echo -e "\n${GREEN}🐧 Installed kernel-related packages...${NC}"
    sudo pacman -Q | grep -E '^linux'

    # Success message
    echo -e "\n${CYAN}✅ System Update and Cleanup completed successfully!${NC}"

# --- Quit ---
elif [[ "$choice" -eq 4 ]]; then
    echo -e "\n${CYAN}🚪 Exiting script. No changes made.${NC}"
    exit 0

else
    echo -e "\n${RED}Invalid choice. Please run the script again and choose either 1, 2, 3, or 4.${NC}"
fi
