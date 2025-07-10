#!/usr/bin/env python3
import subprocess
import os
import re
def get_duration(path):
    try:
        result = subprocess.run(
            ["ffprobe", "-v", "error", "-show_entries", "format=duration",
             "-of", "default=noprint_wrappers=1:nokey=1", path],
            stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, text=True
        )
        return float(result.stdout.strip())
    except:
        return 0

def format_duration(seconds):
    total = int(seconds)
    hrs = total // 3600
    mins = (total % 3600) // 60
    return f"{hrs}hr{mins:02d}min"

def clean_name(name):
    return re.sub(r'\s+\d+hr\d+min$', '', name)  # remove existing duration suffix

def main(root="."):
    for folder, _, files in os.walk(root):
        if folder == root:
            continue  # skip root

        total = 0
        count = 0

        for file in files:
            if file.lower().endswith(".mp4"):
                fpath = os.path.join(folder, file)
                total += get_duration(fpath)
                count += 1

        if count > 0:
            formatted = format_duration(total)
            base = os.path.basename(folder)
            parent = os.path.dirname(folder)
            cleaned = clean_name(base)
            new_name = f"{cleaned} {formatted}"
            new_path = os.path.join(parent, new_name)

            if new_path != folder:
                print(f"📁 Renaming: {folder} → {new_path}")
                os.rename(folder, new_path)

if __name__ == "__main__":
    main()

"""
rename_folders_with_video_duration.py

This script scans subfolders for `.mp4` video files, calculates the total duration
of videos inside each folder, and renames the folder by appending its total duration
in the format: "<original folder name> XhrYYmin".

Example:
    ./9 - Matrices  →  ./9 - Matrices 2hr18min

It ensures that repeated runs do not duplicate duration suffixes by stripping any
existing "XhrYYmin" pattern before renaming.

Dependencies:
    - ffprobe (part of ffmpeg): used to extract video duration.

Usage:
    $ python3 rename_folders_with_video_duration.py
    or
    $ chmod +x rename_folders_with_video_duration.py && ./rename_folders_with_video_duration.py

Safe to re-run. Only affects folders containing .mp4 files.
"""
