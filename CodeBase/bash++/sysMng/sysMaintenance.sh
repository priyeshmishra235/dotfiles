#!/bin/bash

set -euo pipefail

# -------------------------
# Colors
# -------------------------
GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m'

# -------------------------
# Header
# -------------------------
echo -e "${CYAN}[=] Arch Linux System Update & Cleanup Script${NC}"
echo -e "${YELLOW}$(date)${NC}\n"

# -------------------------
# Menu (intentional user input)
# -------------------------
echo -e "${YELLOW}Select an option:${NC}"
echo -e "1) ${GREEN}System Update${NC}"
echo -e "2) ${GREEN}System Cleanup${NC}"
echo -e "3) ${GREEN}Update then Cleanup${NC}"
echo -e "4) ${RED}Quit${NC}"
read -rp "Enter choice (1–4): " choice

# -------------------------
# Ensure cache directory exists
# -------------------------
CACHE_DIR="$HOME/.cache"
[[ -d "$CACHE_DIR" ]] || mkdir -p "$CACHE_DIR"

# ============================================================
# FUNCTIONS
# ============================================================

update_system() {
    echo -e "\n${CYAN}[>] Updating system packages...${NC}"

    (
        set +e
        sudo pacman -Syu --noconfirm
    )

    if command -v paru &>/dev/null; then
        (
            set +e
            paru -Sua --noconfirm
        )
    fi
}

cleanup_system() {
    echo -e "\n${CYAN}[>] Starting system cleanup...${NC}"

    # -------------------------
    # Pacman lock
    # -------------------------
    echo -e "\n${GREEN}[*] Clearing stale pacman lock...${NC}"
    sudo rm -f /var/lib/pacman/db.lck || true

    # -------------------------
    # Orphan packages
    # -------------------------
    echo -e "\n${GREEN}[*] Removing orphaned packages...${NC}"
    orphans="$(pacman -Qdtq 2>/dev/null || true)"
    if [[ -n "$orphans" ]]; then
        (
            set +e
            sudo pacman -Rns $orphans --noconfirm
        )
    else
        echo -e "${YELLOW}[!] No orphaned packages found.${NC}"
    fi

    # -------------------------
    # Broken packages
    # -------------------------
    echo -e "\n${GREEN}[*] Removing broken / invalid local packages...${NC}"
    broken_pkgs="$(
        pacman -Qk 2>/dev/null \
        | awk '/warning:/{print $1}' \
        | sort -u \
        || true
    )"

    if [[ -n "$broken_pkgs" ]]; then
        (
            set +e
            sudo pacman -Rns $broken_pkgs --noconfirm
        )
    else
        echo -e "${YELLOW}[!] No broken local packages found.${NC}"
    fi

    # -------------------------
    # Pacman cache
    # -------------------------
    echo -e "\n${GREEN}[*] Cleaning pacman cache...${NC}"
    (
        set +e
        sudo paccache -rk3
        sudo paccache -ruk0
    )

    # -------------------------
    # Incomplete downloads
    # -------------------------
    echo -e "\n${GREEN}[*] Removing incomplete pacman downloads...${NC}"
    sudo find /var/cache/pacman/pkg -name '*.part' -delete || true

    # -------------------------
    # Sync DB refresh
    # -------------------------
    echo -e "\n${GREEN}[*] Refreshing pacman databases...${NC}"
    (
        set +e
        sudo pacman -Syy --noconfirm
    )

    # -------------------------
    # paru cleanup (AUTO-YES)
    # -------------------------
    echo -e "\n${GREEN}[*] Cleaning paru cache and failed builds...${NC}"
    if command -v paru &>/dev/null; then
        (
            set +e
            paru -Sc --noconfirm
        )
        rm -rf ~/.cache/paru/{clone,build} 2>/dev/null || true
        find ~/.cache/paru -type d -empty -delete 2>/dev/null || true
    else
        echo -e "${YELLOW}[!] paru not installed. Skipping.${NC}"
    fi

    # -------------------------
    # yay cleanup (AUTO-YES)
    # -------------------------
    if command -v yay &>/dev/null; then
        (
            set +e
            yay -Sc --noconfirm
        )
    fi

    # -------------------------
    # User cache (surgical)
    # -------------------------
    echo -e "\n${GREEN}[*] Cleaning selected user caches (non-destructive)...${NC}"
    rm -rf \
        ~/.cache/yay \
        ~/.cache/npm \
        ~/.cache/pip \
        ~/.cache/pipenv \
        ~/.cache/meson \
        ~/.cache/CMakeFiles \
        ~/.cache/go-build \
        ~/.cargo/registry \
        ~/.cargo/git \
        2>/dev/null || true

    find ~/.cache -type f -atime +14 -delete 2>/dev/null || true

    # -------------------------
    # Temp directories
    # -------------------------
    echo -e "\n${GREEN}[*] Cleaning temp directories...${NC}"
    sudo rm -rf /tmp/* /var/tmp/* 2>/dev/null || true

    # -------------------------
    # Journald
    # -------------------------
    echo -e "\n${GREEN}[*] Vacuuming journal logs...${NC}"
    (
        set +e
        sudo journalctl --vacuum-size=100M
    )

    # -------------------------
    # Core dumps
    # -------------------------
    echo -e "\n${GREEN}[*] Purging core dumps...${NC}"
    sudo coredumpctl purge 2>/dev/null || true

    # -------------------------
    # Font cache
    # -------------------------
    echo -e "\n${GREEN}[*] Rebuilding font cache...${NC}"
    rm -rf ~/.cache/fontconfig 2>/dev/null || true
    sudo rm -rf /var/cache/fontconfig/* 2>/dev/null || true
    fc-cache -r >/dev/null 2>&1 || true

    # -------------------------
    # pacnew / pacsave
    # -------------------------
    echo -e "\n${GREEN}[*] pacnew / pacsave files:${NC}"
    sudo find /etc -type f \( -name "*.pacnew" -o -name "*.pacsave" \) 2>/dev/null || true

    # -------------------------
    # Flatpak (AUTO-YES)
    # -------------------------
    if command -v flatpak &>/dev/null; then
        echo -e "\n${GREEN}[*] Cleaning Flatpak...${NC}"
        (
            set +e
            flatpak uninstall --unused -y
        )
        rm -rf ~/.cache/flatpak ~/.var/app/*/cache 2>/dev/null || true
        sudo rm -rf /var/cache/flatpak/* 2>/dev/null || true
    fi

    # -------------------------
    # Snap (AUTO-YES)
    # -------------------------
    if command -v snap &>/dev/null; then
        echo -e "\n${GREEN}[*] Cleaning Snap...${NC}"
        (
            set +e
            snap list --all | awk '/disabled/{print $1, $3}' | \
            while read -r name rev; do
                sudo snap remove --purge "$name" --revision="$rev" -y
            done
        )
        sudo rm -rf /var/lib/snapd/cache/* 2>/dev/null || true
    fi

    echo -e "\n${CYAN}[+] System cleanup completed successfully.${NC}"
}

# ============================================================
# MAIN
# ============================================================

case "$choice" in
    1) update_system ;;
    2) cleanup_system ;;
    3)
        update_system
        cleanup_system
        ;;
    4)
        echo -e "\n${CYAN}[=] Exiting. No changes made.${NC}"
        exit 0
        ;;
    *)
        echo -e "\n${RED}[!] Invalid choice.${NC}"
        exit 1
        ;;
esac
