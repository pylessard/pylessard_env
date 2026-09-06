#!/usr/bin/env bash

# Recipe to convert a video to a format my Jellyfin is happy with.
# Encodes to h.264, downscale to 1920x1080 if needed, but does not upscale
# Use color encoding I know Jellyfin works well with.

set -euo pipefail

INPUT="$1"
DEFAULT_OUTPUT="reencoded/$(basename "$INPUT")"
OUTPUT=${2:-"${DEFAULT_OUTPUT}"}

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

echo "Converting [$CODEC ${SW}x${SH} ($TRC)] -> [h.264 ${W}x${H} (bt709)] "

set -x
ffmpeg -i "$INPUT"          \
    -map 0:v                \
    -map 0:a                \
    -map 0:s?               \
    -map_metadata 0         \
    -c:v copy               \
    -c:v:0 libx264          \
    -preset fast -crf 22    \
    -pix_fmt:v:0 yuv420p    \
    -color_primaries bt709  \
    -color_trc bt709        \
    -colorspace bt709       \
    -color_range tv         \
    -filter:v:0 "$VF"       \
    -c:a copy               \
    -c:s copy               \
    "$OUTPUT"

