#!/bin/bash

# === CPU Core and Frequency Manager ===
# 🧠 Enables/disables CPU cores and adjusts CPU frequency on Arch Linux
# Below is for enabling igpu and disabling dgpu
# sudo envycontrol -s integrated --dm sddm
# Requires root privileges
if [[ $EUID -ne 0 ]]; then
  echo -e "\033[1;31mPlease run this script with root privileges.\033[0m"
  exit 1
fi

# --- Menu ---
echo -e "\n\033[1;34m===============================\033[0m"
echo -e "\033[1;32m🔧 CPU Manager for Arch Linux\033[0m"
echo -e "\033[1;34m===============================\033[0m"
echo -e "1) \033[1;33mDisable CPUs from cpu1 to cpu23\033[0m"
echo -e "2) \033[1;33mEnable all CPUs (cpu1 to cpu23)\033[0m"
echo -e "3) \033[1;33mSet CPU frequency range\033[0m"
echo -e "4) \033[1;33mDisable CPUs from a specific starting CPU\033[0m"
echo -e "5) \033[1;33mToggle Intel Turbo Boost\033[0m"
echo -e "6) \033[1;31mQuit\033[0m"
echo -e "\033[1;34m===============================\033[0m"
read -p "Enter your choice [1-6]: " choice

case "$choice" in
  1)
    # Disable CPUs from cpu2 to cpu23
    echo -e "\033[1;34mDisabling CPUs from cpu1 to cpu23...\033[0m"
    for cpu in $(seq 1 23); do
        echo 0 > /sys/devices/system/cpu/cpu$cpu/online
    done
    echo -e "\033[1;32m✅ CPUs 1 to 23 have been disabled.\033[0m"
    echo -e "ℹ️ \033[1;33mCPU0 cannot be disabled.\033[0m"
    ;;

  2)
    # Enable all CPUs
    echo -e "\033[1;34mEnabling all CPUs from cpu1 to cpu23...\033[0m"
    for cpu in $(seq 1 23); do
        echo 1 > /sys/devices/system/cpu/cpu$cpu/online
    done
    echo -e "\033[1;32m✅ All CPUs from cpu1 to cpu23 have been enabled.\033[0m"
    ;;

  3)
    # Set CPU frequency
    default_lower="0.8G"
    read -p "Enter the upper frequency (e.g., 1.0G): " upper_freq

    # Validate if the upper_freq is a valid frequency
    if [[ ! "$upper_freq" =~ ^[0-9]+(\.[0-9]+)?G$ ]]; then
      echo -e "\033[1;31m❌ Invalid frequency. Please enter a value like 1.0G.\033[0m"
      exit 1
    fi
    cpupower frequency-set -g powersave -d "$default_lower" -u "$upper_freq"
    echo -e "\033[1;32m✅ CPU frequency set to range: $default_lower - $upper_freq\033[0m"
    ;;

  4)
    # Disable CPUs from a specified start CPU
    echo -e "ℹ️ \033[1;33mCPU0 cannot be disabled.\033[0m"
    read -p "Enter the start CPU (from cpu1 to cpu23): " start_cpu

    # Validate if start_cpu is a number
    if ! [[ "$start_cpu" =~ ^[0-9]+$ ]]; then
        echo -e "\033[1;31m❌ Invalid CPU. Please enter a valid number.\033[0m"
        exit 1
    fi

    if [[ "$start_cpu" -lt 1 || "$start_cpu" -gt 23 ]]; then
        echo -e "\033[1;31m❌ Invalid CPU. Please enter a number between 1 and 23.\033[0m"
        exit 1
    fi

    echo -e "\033[1;34mDisabling CPUs from cpu$start_cpu to cpu23...\033[0m"
    for cpu in $(seq "$start_cpu" 23); do
        echo 0 > /sys/devices/system/cpu/cpu$cpu/online
    done
    echo -e "\033[1;32m✅ CPUs from cpu$start_cpu to cpu23 have been disabled.\033[0m"
    ;;

  5)
    # Toggle Intel Turbo Boost
    echo -e "\033[1;34mToggling Intel Turbo Boost...\033[0m"
    read -p "Enter 1 to enable Turbo or 0 to disable Turbo: " turbo_choice
    if [[ "$turbo_choice" -eq 1 ]]; then
      echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo
      echo -e "\033[1;32m✅ Intel Turbo Boost has been enabled.\033[0m"
    elif [[ "$turbo_choice" -eq 0 ]]; then
      echo 0 > /sys/devices/system/cpu/intel_pstate/no_turbo
      echo -e "\033[1;32m✅ Intel Turbo Boost has been disabled.\033[0m"
    else
      echo -e "\033[1;31m❌ Invalid choice. Please enter 1 or 0.\033[0m"
    fi
    ;;

  6)
    # Quit the script
    echo -e "\033[1;31m👋 Exiting...\033[0m"
    exit 0
    ;;

  *)
    echo -e "\033[1;31m❌ Invalid choice. Exiting.\033[0m"
    exit 1
    ;;
esac
