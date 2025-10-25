#!/bin/bash
# this gpt chat will help and give ideas:
# like : having a timer on side while tree is growing
# or something else similar

# cbonsai -h
# Usage: cbonsai [OPTION]...
#
# cbonsai is a beautifully random bonsai tree generator.
#
# Options:
#   -l, --live             live mode: show each step of growth
#   -t, --time=TIME        in live mode, wait TIME secs between
#                            steps of growth (must be larger than 0) [default: 0.03]
#   -i, --infinite         infinite mode: keep growing trees
#   -w, --wait=TIME        in infinite mode, wait TIME between each tree
#                            generation [default: 4.00]
#   -S, --screensaver      screensaver mode; equivalent to -li and
#                            quit on any keypress
#   -m, --message=STR      attach message next to the tree
#   -b, --base=INT         ascii-art plant base to use, 0 is none
#   -c, --leaf=LIST        list of comma-delimited strings randomly chosen
#                            for leaves
#   -M, --multiplier=INT   branch multiplier; higher -> more
#                            branching (0-20) [default: 5]
#   -L, --life=INT         life; higher -> more growth (0-200) [default: 32]
#   -p, --print            print tree to terminal when finished
#   -s, --seed=INT         seed random number generator
#   -W, --save=FILE        save progress to file [default: $XDG_CACHE_HOME/cbonsai or $HOME/.cache/cbonsai]
#   -C, --load=FILE        load progress from file [default: $XDG_CACHE_HOME/cbonsai]
#   -v, --verbose          increase output verbosity
#   -h, --help             show help
# https://chatgpt.com/share/681d0f41-f60c-8007-b129-e08d85bbc0e1
# Bonsai loop that exits when 'q' is pressed

# Background input listener
(while true; do
    read -rsn1 key
    if [[ $key == "q" ]]; then
        kill $$  # kill the main process
    fi
done) &

# Main loop: grow trees repeatedly
while true; do
    cbonsai -l -i 5
    sleep 1
done
