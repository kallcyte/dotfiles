#!/bin/bash

# Emoji Picker for Wofi
# Dependencies: wofi, jq, wl-clipboard, curl

CACHE_FILE="$HOME/.cache/emojis.txt"
JSON_URL="https://raw.githubusercontent.com/muan/emojilib/v2.4.0/emojis.json"

# Check dependencies
for cmd in wofi jq wl-copy curl; do
    if ! command -v "$cmd" &> /dev/null; then
        notify-send "Emoji Picker" "Missing dependency: $cmd"
        exit 1
    fi
done

# Create cache if missing
if [ ! -f "$CACHE_FILE" ] || grep -q -v "span" "$CACHE_FILE"; then
    echo "Updating emoji cache..."
    curl -sL "$JSON_URL" | jq -r 'to_entries | .[] | "\(.value.char) <span size=\"1\">\(.key) \(.value.keywords | join(" "))</span>"' > "$CACHE_FILE"
fi

# Select emoji
SELECTED=$(cat "$CACHE_FILE" | wofi --dmenu --allow-markup --prompt "Search Emoji..." --width 600 --height 400 --columns 6 --insensitive --cache-file /dev/null)

# Copy to clipboard
if [ -n "$SELECTED" ]; then
    EMOJI=$(echo "$SELECTED" | awk '{print $1}')
    echo -n "$EMOJI" | wl-copy
    notify-send "Emoji copied" "$EMOJI"
fi
