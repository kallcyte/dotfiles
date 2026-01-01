#!/bin/bash
# Script to run cava and pipe output to a file for hyprlock

config_file="$HOME/.config/hypr/cava/cava-lock.conf"
output_file="/tmp/cava_lock"

# Ensure cleanup
trap "killall -q cava; rm -f $output_file" EXIT

# Create file
touch "$output_file"

# Custom sed replacement
# 0-7 map to unicode block chars
# " " ▂ ▃ ▄ ▅ ▆ ▇ █
# Note: ascii_max_range=7 so values are 0-7.

dict="s/;//g;s/0/ /g;s/1/▂/g;s/2/▃/g;s/3/▄/g;s/4/▅/g;s/5/▆/g;s/6/▇/g;s/7/█/g;"

# Run cava, pipe to sed, then read loop
cava -p "$config_file" | sed -u "$dict" | while read -r line; do
    echo "$line" > "$output_file"
done
