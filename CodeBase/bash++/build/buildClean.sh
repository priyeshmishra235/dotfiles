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

if [[ -d "$BUILD_DIR" ]]; then
  echo "Deleting build directory: $BUILD_DIR"
  rm -rf "$BUILD_DIR"
  echo "Build directory removed."
else
  echo "Build directory not found: $BUILD_DIR"
fi
