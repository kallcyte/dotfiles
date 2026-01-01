#!/bin/bash
# Wrapper to start cava-lock.sh, run hyprlock, and cleanup

# Start cava in background
~/.config/hypr/scripts/cava-lock.sh &
CAVA_PID=$!

# Run hyprlock (blocking)
hyprlock

# Cleanup
kill $CAVA_PID
