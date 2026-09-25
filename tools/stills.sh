#!/usr/bin/env bash
# stills.sh VIDEO [OUT_DIR] : six evenly spaced stills (JPEG) plus one contact sheet, for eyeballing a render.
set -euo pipefail
V="$1"; OUT="${2:-renders/stills}"; mkdir -p "$OUT"
N="$(basename "${V%.*}")"
D="$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$V")"
i=0
for f in 0.08 0.25 0.42 0.58 0.75 0.92; do
  i=$((i+1)); t="$(awk -v d="$D" -v f="$f" 'BEGIN{printf "%.3f", d*f}')"
  ffmpeg -v error -y -ss "$t" -i "$V" -frames:v 1 -q:v 3 "$OUT/$N-$i.jpg"
done
ffmpeg -v error -y -i "$OUT/$N-1.jpg" -i "$OUT/$N-2.jpg" -i "$OUT/$N-3.jpg" -i "$OUT/$N-4.jpg" -i "$OUT/$N-5.jpg" -i "$OUT/$N-6.jpg" \
  -filter_complex "[0]scale=-2:540[a];[1]scale=-2:540[b];[2]scale=-2:540[c];[3]scale=-2:540[d];[4]scale=-2:540[e];[5]scale=-2:540[f];[a][b][c][d][e][f]hstack=6" -q:v 3 "$OUT/$N-sheet.jpg"
echo "$OUT/$N-[1-6].jpg + $OUT/$N-sheet.jpg"
