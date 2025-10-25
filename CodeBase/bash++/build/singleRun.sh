#!/usr/bin/env bash
set -e

# echo "[&] Initializing..."

# Detect ripgrep or fallback to grep
if command -v rg >/dev/null 2>&1; then
  USE_RG=true
  # echo "[&] ripgrep found."
else
  USE_RG=false
  # echo "[&] ripgrep not found. Falling back to grep (slower)."
fi

# Step 1: Find all .cpp files with 'main()' (only first 100 lines)
main_files=()
for f in *.cpp; do
  [[ -f "$f" ]] || continue
  if $USE_RG; then
    head -n 200 "$f" | rg -q '^\s*(int|auto)\s+main\s*\(' && main_files+=("$f")
  else
    head -n 200 "$f" | grep -qE '^\s*(int|auto)\s+main\s*\(' && main_files+=("$f")
  fi
done

if [[ ${#main_files[@]} -eq 0 ]]; then
  echo "[-] No main() found in first 100 lines of any .cpp file."
  exit 1
elif [[ ${#main_files[@]} -eq 1 ]]; then
  main_cpp="${main_files[0]}"
  echo "[+] Only one entry point found: $main_cpp"
else
  echo "[+] Multiple entry point candidates:"
  for i in "${!main_files[@]}"; do
    echo "    [$i] ${main_files[$i]}"
  done
  while true; do
    read -p "[?] Select index of main file: " index
    if [[ "$index" =~ ^[0-9]+$ ]] && (( index >= 0 && index < ${#main_files[@]} )); then
      main_cpp="${main_files[$index]}"
      echo "[=] Selected: $main_cpp"
      break
    else
      echo "[!] Invalid index. Try again."
    fi
  done
fi

# Step 2: Resolve headers recursively
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
    # echo "[&] Found header: $header"

    base="${header%.*}"
    candidate="${base}.cpp"
    if [[ -f "$candidate" && "$candidate" != "$main_cpp" && -z "${visited_cpp[$candidate]+1}" ]]; then
      visited_cpp["$candidate"]=1
      linked_cpp_files+=("$candidate")
      echo "[+] Matched $header → $candidate"
      resolve_headers "$candidate"
    else
      echo "[-] No source file for: $header"
    fi
  done
}

# Only try to resolve headers if any local includes exist
if grep -qE '^\s*#include\s+"[^"]+\.(h|hpp)"' "$main_cpp"; then
  echo ""
  echo "[&] Resolving dependencies"
  resolve_headers "$main_cpp"
else
  echo ""
  echo "[=] No local headers found in $main_cpp. Skipping dependency resolution."
fi

# Step 3: Compile
linked_cpp_files=("${linked_cpp_files[@]}")  # ensure array initialized
all_files=("$main_cpp" "${linked_cpp_files[@]}")
binary="./$(basename "$main_cpp" .cpp)"

if [[ ${#all_files[@]} -eq 0 ]]; then
  echo "[!] No files to compile. Exiting."
  exit 1
fi

echo ""
echo "[*] Compile command:"
echo "clang++ ${all_files[*]} -std=c++20 -Wall -Wextra -pedantic -O2 -o $binary"

clang++ "${all_files[@]}" -std=c++20 -Wall -Wextra -pedantic -O2 -o "$binary"

# Step 4: Run
echo ""
echo "[=] Running: $binary"
echo "------------------------------------------------------------"
"$binary"
