#!/usr/bin/env bash
set -euo pipefail

cpp_files=($(find . -maxdepth 1 -type f -name "*.cpp"))

if [[ ${#cpp_files[@]} -eq 0 ]]; then
  echo "No .cpp files found in the current directory."
  exit 1
elif [[ ${#cpp_files[@]} -eq 1 ]]; then
  cpp_file="${cpp_files[0]}"
  echo "Found single file: $cpp_file"
else
  echo "Multiple .cpp files found:"
  for i in "${!cpp_files[@]}"; do
    echo "  [$i] ${cpp_files[$i]}"
  done

  while true; do
    read -p " Enter the index of the file to compile for debugging: " index
    if [[ "$index" =~ ^[0-9]+$ ]] && [[ $index -ge 0 ]] && [[ $index -lt ${#cpp_files[@]} ]]; then
      cpp_file="${cpp_files[$index]}"
      break
    else
      echo "Invalid input. Please enter a number between 0 and $(( ${#cpp_files[@]} - 1 ))."
    fi
  done
fi

# Extract filename and directory
cpp_dir=$(dirname "$cpp_file")
cpp_base=$(basename "$cpp_file" .cpp)
binary="${cpp_dir}/${cpp_base}"

# Delete existing binary if exists
if [[ -f "$binary" ]]; then
  echo "[!] Deleting existing binary: $binary"
  rm -f "$binary"
fi

# Compile with debug flags
echo "[+] Compiling $cpp_file -> $binary (debug build)..."
clang++ -g -O0 -std=c++20 -Wall -Wextra -pedantic "$cpp_file" -o "$binary"

# Final message
echo "[✓] Debug binary ready: $binary"
echo "[*] Use this binary path in nvim-dap for debugging."
