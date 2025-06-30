#!/usr/bin/env bash
set -e

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
    read -p " Enter the index of the file to compile and run: " index
    if [[ "$index" =~ ^[0-9]+$ ]] && [[ $index -ge 0 ]] && [[ $index -lt ${#cpp_files[@]} ]]; then
      cpp_file="${cpp_files[$index]}"
      break
    else
      echo "Invalid input. Please enter a number between 0 and $(( ${#cpp_files[@]} - 1 ))."
    fi
  done
fi

# Extract filename without extension
filename=$(basename "$cpp_file" .cpp)
binary="./$filename"

# Compilation
echo "[+] Compiling $cpp_file -> $binary ..."
clang++ "$cpp_file" -std=c++20 -Wall -Wextra -pedantic -O2 -o "$binary"

# Execution
echo "[+] Running $binary ..."
"$binary"
