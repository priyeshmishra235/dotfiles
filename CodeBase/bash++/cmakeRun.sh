#!/usr/bin/env bash
set -euo pipefail

# -------- CONFIG --------
PROJECT_NAME="ConstructorException"
BUILD_DIR=".cmake_build"
BINARY_PATH="./$PROJECT_NAME"
COMPILE_COMMANDS="./compile_commands.json"
CMAKELIST_FILE="CMakeLists.txt"
# ------------------------

if [[ "${1:-}" == "clean" ]]; then
  echo "[&] Cleaning..."
  rm -rf "$BUILD_DIR" "$BINARY_PATH" "$COMPILE_COMMANDS" "$CMAKELIST_FILE"
  exit 0
fi

echo "[&] Generating CMakeLists.txt..."

{
cat <<EOF
cmake_minimum_required(VERSION 3.16)
project(${PROJECT_NAME} LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_compile_options(-Wall -Wextra -pedantic)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "\${CMAKE_SOURCE_DIR}")
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_executable(\${PROJECT_NAME}
EOF

# Append all .cpp files in the current directory
for cpp in ./*.cpp; do
  [[ -f "$cpp" ]] && echo "  $(basename "$cpp")"
done

echo ")"

} > "$CMAKELIST_FILE"

echo "[&] Configuring with CMake..."
cmake -S . -B "$BUILD_DIR" \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
  -DCMAKE_RUNTIME_OUTPUT_DIRECTORY="$(pwd)"

echo "[&] Building project..."
cmake --build "$BUILD_DIR" --target "$PROJECT_NAME" --parallel

echo "[&] Copying compile_commands.json to root..."
cp "$BUILD_DIR/compile_commands.json" "$COMPILE_COMMANDS" || true

echo "[&] Cleaning temporary build directory..."
rm -rf "$BUILD_DIR"

echo "[=] Running binary: $BINARY_PATH"
echo "------------------------------------------------------------"
"$BINARY_PATH"
