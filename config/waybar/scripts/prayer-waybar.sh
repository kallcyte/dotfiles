#!/bin/bash

# 1. Get Raw Data
# Clean colors and tabs immediately
NEXT_RAW=$(go-pray next | sed 's/\x1b\[[0-9;]*m//g' | tr -s ' ' | tr -d '\r')
CAL_RAW=$(go-pray calendar | sed 's/\x1b\[[0-9;]*m//g' | tr -s ' ' | tr -d '\r')

# 2. Parse "Next" Info
# Input: "Fajr in 03:25"
NEXT_NAME=$(echo "$NEXT_RAW" | awk '{print $1}')
COUNTDOWN=$(echo "$NEXT_RAW" | awk '{print $3}')

# 3. Parse Individual Times for Tooltip (Safest Method)
# We find the line, remove the name/colon, and grab the time.
get_time() {
  echo "$CAL_RAW" | grep -i "^$1" | sed "s/$1: //I" | xargs
}

T_FAJR=$(get_time "Fajr")
T_DHUHR=$(get_time "Dhuhr")
T_ASR=$(get_time "Asr")
T_MAGHRIB=$(get_time "Maghrib")
T_ISHA=$(get_time "Isha")

# 4. Get Actual Time for the Bar
# We just map the NEXT_NAME to the time we just extracted
case $NEXT_NAME in
"Fajr") ACTUAL_TIME=$T_FAJR ;;
"Dhuhr") ACTUAL_TIME=$T_DHUHR ;;
"Asr") ACTUAL_TIME=$T_ASR ;;
"Maghrib") ACTUAL_TIME=$T_MAGHRIB ;;
"Isha") ACTUAL_TIME=$T_ISHA ;;
*) ACTUAL_TIME="--" ;;
esac

# 5. Build Safe Tooltip String
# We manually construct the string with literal \n characters
TOOLTIP_STR="Gresik (go-pray)\n----------------\nFajr: $T_FAJR\nDhuhr: $T_DHUHR\nAsr: $T_ASR\nMaghrib: $T_MAGHRIB\nIsha: $T_ISHA"

# 6. Output JSON
if [ -z "$NEXT_NAME" ]; then
  echo '{"text": "Loading...", "class": "offline"}'
else
  # Output is guaranteed valid because we built the strings ourselves
  echo "{\"text\": \"🕌 $NEXT_NAME $ACTUAL_TIME (-$COUNTDOWN)\", \"tooltip\": \"$TOOLTIP_STR\", \"class\": \"prayer\"}"
fi
