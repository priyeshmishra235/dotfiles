#!/bin/bash
set -e

RAPL="/sys/class/powercap/intel-rapl:0"
BAT="/sys/class/power_supply/BAT1/status"

[ -d "$RAPL" ] || exit 1

apply_limits() {
    echo "$1" > "$RAPL/constraint_0_power_limit_uw"
    echo "$2" > "$RAPL/constraint_1_power_limit_uw"
}

case "$1" in
    study)
        apply_limits 12000000 15000000
        ;;
    normal)
        apply_limits 18000000 22000000
        ;;
    ac)
        apply_limits 55000000 80000000
        ;;
    emergency)
        apply_limits 8000000 10000000
        ;;
    auto)
        if grep -q "Discharging" "$BAT"; then
            apply_limits 12000000 15000000
        else
            apply_limits 55000000 80000000
        fi
        ;;
    *)
        echo "Usage: power-mode {study|normal|ac|emergency|auto}"
        exit 1
        ;;
esac

