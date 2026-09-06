#!/usr/bin/env bash
set -euo pipefail

INPUT="$1"
BASENAME="$(basename ${INPUT%.*})"

CODEC=$(ffprobe -v error -select_streams a:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$INPUT")

case "$CODEC" in
    aac)       EXT="aac" ;;
    mp3)       EXT="mp3" ;;
    ac3)       EXT="ac3" ;;
    eac3)      EXT="eac3" ;;
    dts)       EXT="dts" ;;
    flac)      EXT="flac" ;;
    opus)      EXT="opus" ;;
    vorbis)    EXT="ogg" ;;
    pcm_*)     EXT="wav" ;;
    *)         EXT="$CODEC" ;;
esac
mkdir -p audio

set -x 
ffmpeg -i "$INPUT" -map 0:a:0 -c:a copy "audio/${BASENAME}.${EXT}"