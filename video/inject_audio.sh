#!/usr/bin/env bash
set -euo pipefail


INPUT="$1"
INPUT_AUDIO="$2"
DEFAULT_OUTPUT="injected/$(basename "$INPUT")"
OUTPUT=${3:-"${DEFAULT_OUTPUTDEFAULT_OUTPUT}"}

AUDIO_DELAY="0"   # seconds (positive = shift forward, negative = shift back)
AUDIO_TITLE="French"

# --- do not edit below ---
AUDIO_COUNT=$(ffprobe -v error -select_streams a -show_entries stream=index -of csv=p=0 "$INPUT" | wc -l)

mkdir -p injected
set -x
ffmpeg -i "$INPUT" -itsoffset "$AUDIO_DELAY" -i "$INPUT_AUDIO" \
    -map 0 -map 1:a:0 \
    -c copy \
    -metadata:s:a:"$AUDIO_COUNT" title="$AUDIO_TITLE" \
    "$OUTPUT"