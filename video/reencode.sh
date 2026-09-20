#!/usr/bin/env bash

# Recipe to convert a video to a format my Jellyfin is happy with.
# Encodes to h.264, downscale to 1920x1080 if needed, but does not upscale
# Use color encoding I know Jellyfin works well with.

set -euo pipefail

AUDIO_ONLY=false
POSITIONAL=()
for arg in "$@"; do
    case "$arg" in
        --audio-only) AUDIO_ONLY=true ;;
        *) POSITIONAL+=("$arg") ;;
    esac
done

INPUT="${POSITIONAL[0]}"
DEFAULT_OUTPUT="reencoded/$(basename "$INPUT")"
OUTPUT=${POSITIONAL[1]:-"${DEFAULT_OUTPUT}"}

mkdir -p reencoded

MAXW=1920
MAXH=1080

IFS=$',\r' read -r CODEC  SW SH TRC < <(ffprobe -v error -select_streams v:0 \
  -show_entries stream=codec_name,width,height,color_transfer \
  -of csv=p=0 "$INPUT")

if (( SW <= MAXW && SH <= MAXH )); then
    W=$SW; H=$SH
elif (( SW * MAXH > MAXW * SH )); then
    W=$MAXW; H=$(( SH * MAXW / SW ))
else
    H=$MAXH; W=$(( SW * MAXH / SH ))
fi

W=$(( W / 2 * 2 ))
H=$(( H / 2 * 2 ))

VF=""
VF+="zscale=t=linear:npl=200,format=gbrpf32le"
VF+=",zscale=w=${W}:h=${H}:p=bt709:f=lanczos"
VF+=",tonemap=tonemap=mobius:param=0.3:desat=0"
VF+=",zscale=t=bt709:m=bt709:r=tv:d=error_diffusion"
VF+=",format=yuv420p,setsar=1"


VIDEO_OPTS=()
if [[ "$AUDIO_ONLY" == true ]]; then
    echo "Audio-only mode — copying video [$CODEC ${SW}x${SH}]"
    VIDEO_OPTS+=(-c:v copy)
else
    echo "Converting [$CODEC ${SW}x${SH} ($TRC)] -> [h.264 ${W}x${H} (bt709)]"
    VIDEO_OPTS+=(
        -c:v h264
        -preset fast -crf 22
        -pix_fmt:v:0 yuv420p
        -color_primaries bt709
        -color_trc bt709
        -colorspace bt709
        -color_range tv
        -filter:v:0 "$VF"
    )
fi

set -x
ffmpeg -i "$INPUT"          \
    -map 0:v                \
    -map 0:a                \
    -map 0:s?               \
    -map_metadata 0         \
    "${VIDEO_OPTS[@]}"      \
    -c:a aac -b:a 256k      \
    -c:s copy               \
    "$OUTPUT"

