#!/usr/bin/env bash
set -eo pipefail

RECORDER="wf-recorder"
SAVE_DIR="${XDG_VIDEOS_DIR:-$HOME/Videos}/Recordings"

if ! command -v "$RECORDER" &>/dev/null; then
  notify-send -a "System Alert" "wf-recorder not found. Please install it: sudo pacman -S wf-recorder"
  exit 1
fi

USAGE() {
  cat <<USAGE
Usage: record.sh [option]

Options:
    --start      Start recording (select region with mouse)
    --file       Specify custom output path
    --quit       Stop the recording
    --help       Show this help message
    --           Pass extra args to wf-recorder (e.g. -- --audio)
USAGE
}

handle_recording() {
  mkdir -p "$SAVE_DIR"
  save_file=$(date +'%y%m%d_%Hh%Mm%Ss_recording.mp4')
  save_file_path="${FILE_PATH:-"$SAVE_DIR/$save_file"}"

  parameters=()
  while [[ $# -gt 0 ]]; do
    if [[ $1 == "--" ]]; then
      shift
      parameters+=("$@")
      break
    fi
    shift
  done

  GEOM=$(slurp -b "#00000000" -c "#FFFFFF" -s "#00000055")

  if [[ -n $GEOM ]]; then
    parameters+=("-g" "$GEOM")
  else
    OUTPUT=$(hyprctl -j monitors | jq -r '.[] | select(.focused==true) | .name')
    parameters+=("-o" "$OUTPUT")
  fi

  tmp_thumb=$(mktemp -t thumb_XXXX.png)
  grim ${GEOM:+-g "$GEOM"} "$tmp_thumb"

  notify-send -a "Recorder" "Recording Started..." -i "$tmp_thumb"

  "$RECORDER" "${parameters[@]}" -f "$save_file_path"

  notify-send -a "Recorder" "Recording saved to $save_file_path" -i "$tmp_thumb"
}

if [[ $# -eq 0 ]]; then
  USAGE
  exit 1
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
  --file)
    shift
    FILE_PATH="$1"
    ;;
  --start)
    handle_recording "$@"
    exit 0
    ;;
  --quit)
    killall -s SIGINT "$RECORDER"
    exit 0
    ;;
  --help)
    USAGE
    exit 0
    ;;
  *)
    USAGE
    exit 1
    ;;
  esac
  shift
done
