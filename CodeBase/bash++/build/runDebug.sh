#!/usr/bin/env bash
set -e

get_project_root() {
  local dir
  dir=$(realpath .)
  local last_found=""

  while [[ "$dir" != "/" ]]; do
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
# ln -sf "$BUILD_DIR/compile_commands.json" "$PROJECT_ROOT/compile_commands.json"
echo "[+] Debug build completed successfully."

EXECUTABLE=$(find "$BUILD_DIR/bin" -type f -executable | head -n 1)
if [[ -z "$EXECUTABLE" || ! -x "$EXECUTABLE" ]]; then
  echo "[-] No executable found in build directory." >&2
  exit 1
fi
echo "[*] Found executable: $EXECUTABLE"

DAP_LAUNCH_JSON="$PROJECT_ROOT/.nvim-dap-launch.json"
cat > "$DAP_LAUNCH_JSON" <<EOF
{
  "type": "codelldb",
  "request": "launch",
  "name": "Launch $EXECUTABLE",
  "program": "$EXECUTABLE",
  "args": [],
  "cwd": "$PROJECT_ROOT",
  "stopOnEntry": false
}
EOF
nvim "$PROJECT_ROOT" -c "lua require('plugins.debugger.myDapLauncher').launch_from_json('$DAP_LAUNCH_JSON')"
echo "[+] Generated DAP config at $DAP_LAUNCH_JSON"
