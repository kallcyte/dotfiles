#!/bin/bash

# Define the max length of the text before it scrolls
LENGTH=25

# Check if playerctl is running
if ! pgrep -x "playerctl" >/dev/null; then
  # Start zscroll monitoring playerctl
  zscroll -l $LENGTH \
    --delay 0.2 \
    --match-command "playerctl status" \
    --match-text "Playing" "--scroll 1" \
    --match-text "Paused" "--scroll 0" \
    --update-check true \
    "playerctl metadata --format '{{ artist }} - {{ title }}'" &
  wait
fi
