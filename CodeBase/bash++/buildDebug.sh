#!/usr/bin/env bash
set -e

get_project_root() {
  local dir=$(realpath .)
  local last_found=""

  while [[ "$dir" != "/" ]]; do
    # if [[ -f "$dir/CMakeLists.txt" || -d "$dir/.git" ]]; then
    if [[ -f "$dir/CMakeLists.txt" ]]; then
      last_found="$dir"
    fi
    dir=$(dirname "$dir")
  done

  if [[ -n "$last_found" ]]; then
    echo "$last_found"
  else
    echo "Error: Could not find project root" >&2
    exit 1
  fi
}

PROJECT_ROOT=$(get_project_root)
BUILD_DIR="$PROJECT_ROOT/build"

echo "[*] Building Debug in $BUILD_DIR"

mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

CXX=clang++ CC=clang cmake -G Ninja -DCMAKE_BUILD_TYPE=Debug -DCMAKE_EXPORT_COMPILE_COMMANDS=ON "$PROJECT_ROOT"
ninja

ln -sf "$BUILD_DIR/compile_commands.json" "$PROJECT_ROOT/compile_commands.json"

echo "[+] Debug build completed successfully."
