#!/bin/bash
# === CPU Core and Frequency Manager ===
# Intel HX-class CPU safe power control
# Requires root

if [[ $EUID -ne 0 ]]; then
  echo "Run as root"
  exit 1
fi

PSTATE="/sys/devices/system/cpu/intel_pstate/no_turbo"
RAPL="/sys/class/powercap/intel-rapl:0"
BAT="/sys/class/power_supply/BAT1/status"

# ---------------- TURBO ----------------
enable_turbo() {
    cpupower frequency-set -g performance >/dev/null 2>&1
    echo 0 > "$PSTATE"
}

disable_turbo() {
    echo 1 > "$PSTATE"
    cpupower frequency-set -g powersave >/dev/null 2>&1
}

turbo_status() {
    [[ "$(cat $PSTATE)" == "0" ]] && echo "ON" || echo "OFF"
}

# ---------------- POWER MODE ----------------
set_power_mode() {
    echo "1) Performance"
    echo "2) Balanced"
    echo "3) Powersave"
    read -p "Mode: " mode

    case "$mode" in
        1)
            cpupower frequency-set -g performance
            for c in /sys/devices/system/cpu/cpu*/power/energy_perf_bias; do
                echo 0 > "$c" 2>/dev/null
            done
            ;;
        2)
            cpupower frequency-set -g schedutil
            for c in /sys/devices/system/cpu/cpu*/power/energy_perf_bias; do
                echo 6 > "$c" 2>/dev/null
            done
            ;;
        3)
            cpupower frequency-set -g powersave
            for c in /sys/devices/system/cpu/cpu*/power/energy_perf_bias; do
                echo 15 > "$c" 2>/dev/null
            done
            ;;
    esac
}

# ---------------- RAW POWER LIMITS ----------------
set_power_limits() {
    if [[ ! -d "$RAPL" ]]; then
        echo "RAPL not supported"
        return
    fi

    read -p "PL1 (watts): " pl1
    read -p "PL2 (watts): " pl2

    echo $((pl1*1000000)) > "$RAPL/constraint_0_power_limit_uw"
    echo $((pl2*1000000)) > "$RAPL/constraint_1_power_limit_uw"

    echo "Power limits applied"
}

# ---------------- POWER PROFILES ----------------
apply_limits() {
    echo "$1" > "$RAPL/constraint_0_power_limit_uw"
    echo "$2" > "$RAPL/constraint_1_power_limit_uw"
}

set_power_profile() {
    if [[ ! -d "$RAPL" ]]; then
        echo "RAPL not supported"
        return
    fi

    echo "1) Study     (12W / 15W)"
    echo "2) Normal    (18W / 22W)"
    echo "3) AC Power  (55W / 80W)"
    echo "4) Emergency (8W / 10W)"
    echo "5) Auto (battery aware)"
    read -p "Select profile: " p

    case "$p" in
        1) apply_limits 12000000 15000000 ;;
        2) apply_limits 18000000 22000000 ;;
        3) apply_limits 55000000 80000000 ;;
        4) apply_limits 8000000 10000000 ;;
        5)
            if grep -q "Discharging" "$BAT"; then
                apply_limits 12000000 15000000
            else
                apply_limits 55000000 80000000
            fi
            ;;
        *) echo "Invalid profile" ;;
    esac
}

# ---------------- P / E CORES ----------------
set_core_freqs() {
    read -p "P-core max GHz: " p
    read -p "E-core max GHz: " e

    for cpu in /sys/devices/system/cpu/cpu[0-9]*; do
        id=$(basename "$cpu" | tr -d cpu)
        if (( id < 16 )); then
            echo $((p*1000000)) > "$cpu/cpufreq/scaling_max_freq"
        else
            echo $((e*1000000)) > "$cpu/cpufreq/scaling_max_freq"
        fi
    done

    echo "Cluster limits set"
}

# ---------------- MENU ----------------
echo "=========================="
echo "CPU Manager"
echo "=========================="
echo "1) Disable CPUs 1–23"
echo "2) Enable CPUs 1–23"
echo "3) Set CPU frequency range"
echo "4) Disable CPUs from index"
echo "5) Toggle Turbo"
echo "6) Set Power Mode (governor + HWP)"
echo "7) Set PL1 / PL2 (manual watts)"
echo "8) Power Profiles (study / ac / auto)"
echo "9) Set P-core / E-core max freq"
echo "10) Quit"
echo "=========================="
read -p "Choice: " choice

case "$choice" in
  1) for cpu in $(seq 1 23); do echo 0 > /sys/devices/system/cpu/cpu$cpu/online; done ;;
  2) for cpu in $(seq 1 23); do echo 1 > /sys/devices/system/cpu/cpu$cpu/online; done ;;
  3)
    read -p "Upper GHz: " u
    cpupower frequency-set -g powersave -d 0.8G -u "$u"
    ;;
  4)
    read -p "Start CPU: " s
    for cpu in $(seq "$s" 23); do echo 0 > /sys/devices/system/cpu/cpu$cpu/online; done
    ;;
  5)
    echo "Turbo is $(turbo_status)"
    read -p "1=Enable 0=Disable: " t
    [[ "$t" == "1" ]] && enable_turbo || disable_turbo
    ;;
  6) set_power_mode ;;
  7) set_power_limits ;;
  8) set_power_profile ;;
  9) set_core_freqs ;;
  10) exit 0 ;;
  *) echo "Invalid" ;;
esac
