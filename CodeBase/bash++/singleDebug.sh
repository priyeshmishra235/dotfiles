#!/usr/bin/env bash
set -e

echo "[&] Initializing debug build..."

# -------------------------------
# Step 0: Tool detection
# -------------------------------
if command -v rg >/dev/null 2>&1; then
  USE_RG=true
  echo "[&] ripgrep found. Using fast scanning."
else
  USE_RG=false
  echo "[&] ripgrep not found. Falling back to grep (slower)."
fi

# -------------------------------
# Step 1: Find .cpp files with main()
# -------------------------------
echo "[&] Scanning for .cpp files containing main()..."

main_files=()
for f in *.cpp; do
  [[ -f "$f" ]] || continue
  if $USE_RG; then
    head -n 100 "$f" | rg -q '^\s*(int|auto)\s+main\s*\(' && main_files+=("$f")
  else
    head -n 100 "$f" | grep -qE '^\s*(int|auto)\s+main\s*\(' && main_files+=("$f")
  fi
done

if [[ ${#main_files[@]} -eq 0 ]]; then
  echo "[-] No .cpp file with a main() function found."
  exit 1
elif [[ ${#main_files[@]} -eq 1 ]]; then
  main_cpp="${main_files[0]}"
  echo "[+] Only one main file found: $main_cpp"
else
  echo "[+] Found ${#main_files[@]} .cpp files with main():"
  for i in "${!main_files[@]}"; do
    echo "    [$i] ${main_files[$i]}"
  done
  echo ""

  while true; do
    read -p "[?] Enter index of the file to compile: " index
    if [[ "$index" =~ ^[0-9]+$ ]] && (( index >= 0 && index < ${#main_files[@]} )); then
      main_cpp="${main_files[$index]}"
      echo "[=] Using: $main_cpp"
      break
    else
      echo "[!] Invalid index. Try again."
    fi
  done
fi

# -------------------------------
# Step 2: Recursively resolve headers
# -------------------------------
echo ""
echo "[&] Resolving headers recursively..."

declare -A visited_headers
declare -A visited_cpp
linked_cpp_files=()

resolve_headers() {
  local source="$1"
  local includes=()

  if $USE_RG; then
    includes=($(head -n 100 "$source" | rg '^\s*#include\s+"([^"]+\.(h|hpp))"' -o --replace '$1'))
  else
    while IFS= read -r line; do
      header=$(echo "$line" | sed -E 's/.*"([^"]+)".*/\1/')
      [[ -n "$header" ]] && includes+=("$header")
    done < <(head -n 100 "$source" | grep -E '^\s*#include\s+"[^"]+\.(h|hpp)"')
  fi

  for header in "${includes[@]}"; do
    [[ -n "$header" && -z "${visited_headers[$header]+1}" ]] || continue
    visited_headers["$header"]=1
    echo "[&] Found header: $header"

    base="${header%.*}"
    candidate="${base}.cpp"
    if [[ -f "$candidate" && "$candidate" != "$main_cpp" && -z "${visited_cpp[$candidate]+1}" ]]; then
      visited_cpp["$candidate"]=1
      linked_cpp_files+=("$candidate")
      echo "[+] Matched $header → $candidate"
      resolve_headers "$candidate"
    else
      echo "[-] No source file found for: $header"
    fi
  done
}

# Optional: Skip resolution if no local includes
if grep -qE '^\s*#include\s+"[^"]+\.(h|hpp)"' "$main_cpp"; then
  resolve_headers "$main_cpp"
else
  echo "[=] No local headers found in $main_cpp. Skipping dependency resolution."
fi

# -------------------------------
# Step 3: Compile
# -------------------------------
all_files=("$main_cpp" "${linked_cpp_files[@]}")
binary="./$(basename "$main_cpp" .cpp)"

if [[ -f "$binary" ]]; then
  echo "[!] Removing existing binary: $binary"
  rm -f "$binary"
fi

echo ""
echo "[*] Compiling debug binary:"
echo "    clang++ ${all_files[*]} -g -O0 -std=c++20 -Wall -Wextra -pedantic -o $binary"
clang++ "${all_files[@]}" -g -O0 -std=c++20 -Wall -Wextra -pedantic -o "$binary"

# -------------------------------
# Step 4: Final Output
# -------------------------------
echo ""
echo "[✓] Debug binary created: $binary"
echo "[*] Use this path in nvim-dap or gdb for debugging."
