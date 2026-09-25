#!/usr/bin/env bash
# make-sound.sh: an 18 second warm music bed with hits on the reel's beats.
# Pure FFmpeg synthesis (layered sine waves with envelopes, plus filtered noise).
# No samples, no downloads, no licences to worry about.
#
#   bash tools/make-sound.sh                 -> assets/audio/bed.wav
#   bash tools/make-sound.sh out.wav
#
# TEMPLATE from the SV Motion OrderDi example. The hit times below are that reel's
# beats (hook 0 to 3.0, logo 3.25, phone 4.9, callouts 6.2 / 8.4 / 10.8, tagline
# slams 12.8 to 13.7, close sting 15.6). Move them to your own beat list, and change
# DUR and the final afade start if your video is not 18 seconds long.
set -euo pipefail
OUT="${1:-assets/audio/bed.wav}"
mkdir -p "$(dirname "$OUT")"
DUR=18
TMP="$(mktemp -d)"

# pluck T0 FREQ DECAY AMP : marimba-like hit (fundamental + 4x partial, exponential decay)
pluck() { echo "$4*(sin(2*PI*$2*t)+0.30*sin(2*PI*$2*4*t))*exp(-$3*(t-$1))*gte(t,$1)"; }
# bell T0 FREQ DECAY AMP : inharmonic bell (1, 2.76, 5.4 partials)
bell() { echo "$4*(sin(2*PI*$2*t)+0.45*sin(2*PI*$2*2.76*t)*exp(-2*(t-$1))+0.2*sin(2*PI*$2*5.4*t)*exp(-4*(t-$1)))*exp(-$3*(t-$1))*gte(t,$1)"; }
# thump T0 FREQ AMP : low body hit with a small pitch drop
thump() { echo "$3*sin(2*PI*($2*(t-$1)-18*(t-$1)*(t-$1)))*exp(-11*(t-$1))*gte(t,$1)"; }
# env A B C D : 0 before A, ramps up A..B, holds, ramps down C..D
env() { echo "(clip((t-$1)/($2-$1),0,1)*clip(($4-t)/($4-$3),0,1))"; }

# Hook pad: tense A minor colour, slow tremolo (0 to 3.5 s)
PAD1="$(env 0.0 1.0 3.1 3.7)*(0.9+0.1*sin(2*PI*2.5*t))*(0.060*sin(2*PI*110*t)+0.045*sin(2*PI*164.81*t)+0.035*sin(2*PI*261.63*t)+0.020*sin(2*PI*220.9*t))"
# Main pad: warm A major (3.3 to 12.8 s)
PAD2="$(env 3.3 4.4 12.2 12.9)*(0.050*sin(2*PI*110*t)+0.040*sin(2*PI*164.81*t)+0.034*sin(2*PI*220*t)+0.028*sin(2*PI*277.18*t)+0.022*sin(2*PI*329.63*t)+0.010*sin(2*PI*440.7*t))"
# Tagline pad: D major lift (12.5 to 15.8 s)
PAD3="$(env 12.5 13.2 15.2 15.9)*(0.050*sin(2*PI*146.83*t)+0.040*sin(2*PI*220*t)+0.032*sin(2*PI*293.66*t)+0.026*sin(2*PI*369.99*t)+0.016*sin(2*PI*440*t))"
# Close pad: A major, fades to silence by 18 s
PAD4="$(env 15.4 16.2 17.0 18.0)*(0.050*sin(2*PI*110*t)+0.040*sin(2*PI*164.81*t)+0.032*sin(2*PI*277.18*t)+0.026*sin(2*PI*329.63*t)+0.018*sin(2*PI*440*t))"
# Hook heartbeat
BEAT="$(thump 0.20 62 0.42)+$(thump 0.95 62 0.36)+$(thump 1.70 62 0.40)+$(thump 2.45 62 0.34)"
# Logo chime, callout plucks, tagline slams, closing sting
HITS="$(bell 3.25 880 2.2 0.10)+$(bell 3.25 1318.5 2.6 0.05)"
HITS="$HITS+$(pluck 6.20 659.26 6 0.11)+$(pluck 8.40 880 6 0.11)+$(pluck 10.78 1108.73 6 0.10)"
HITS="$HITS+$(thump 12.80 98 0.40)+$(thump 13.10 110 0.38)+$(thump 13.40 123.5 0.38)+$(thump 13.70 146.8 0.42)"
HITS="$HITS+$(bell 14.05 587.33 1.6 0.07)+$(bell 14.05 880 1.8 0.05)"
HITS="$HITS+$(thump 15.60 55 0.50)+$(bell 15.62 440 0.9 0.09)+$(bell 15.62 554.37 1.0 0.07)+$(bell 15.62 659.26 1.1 0.06)+$(bell 15.64 880 1.3 0.05)"

L="$PAD1+$PAD2+$PAD3+$PAD4+$BEAT+$HITS"
# Right channel: same, with pads detuned a hair for width
R="$(echo "$L" | sed -e 's/2\*PI\*110\*t/2*PI*110.4*t/g' -e 's/2\*PI\*164.81\*t/2*PI*165.3*t/g')"

ffmpeg -v error -y -f lavfi -i "aevalsrc=exprs='$L|$R':s=48000:d=$DUR" -c:a pcm_s16le "$TMP/tones.wav"

# Whooshes on the scene changes: pink noise through a band-pass, gated by an envelope
W="0.9*$(env 2.80 3.10 3.15 3.60)+0.6*$(env 4.70 5.00 5.10 5.60)+0.8*$(env 12.10 12.45 12.50 12.95)+0.9*$(env 15.05 15.40 15.45 15.95)"
ffmpeg -v error -y -f lavfi -i "anoisesrc=color=pink:seed=7:amplitude=0.5:d=$DUR:r=48000" \
  -af "highpass=f=500,lowpass=f=4200,asetnsamples=n=256,volume='0.55*($W)':eval=frame,pan=stereo|c0=c0|c1=c0" \
  -c:a pcm_s16le "$TMP/air.wav"

# Mix, gentle glue, normalise to a social-video loudness, fade the tail
ffmpeg -v error -y -i "$TMP/tones.wav" -i "$TMP/air.wav" \
  -filter_complex "[0][1]amix=inputs=2:normalize=0,acompressor=threshold=-18dB:ratio=2:attack=20:release=250,loudnorm=I=-16:TP=-1.5:LRA=11,afade=t=out:st=17.4:d=0.6,aresample=48000" \
  -ac 2 -ar 48000 -c:a pcm_s16le "$OUT"
rm -rf "$TMP"
echo "wrote $OUT"
