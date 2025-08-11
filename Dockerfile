#!/bin/bash
set -e

if [ -z "$STREAM_URL" ] || [ -z "$STREAM_KEY" ]; then
  echo "ERROR: STREAM_URL and STREAM_KEY must be set as environment variables."
  exit 1
fi

ffmpeg -hide_banner -loglevel info \
  -f lavfi -i color=size=1280x720:rate=30:color=black \
  -f lavfi -i anullsrc=channel_layout=stereo:sample_rate=44100 \
  -c:v libx264 -preset veryfast -b:v 1200k -maxrate 1200k -bufsize 2400k \
  -pix_fmt yuv420p -r 30 -g 60 \
  -c:a aac -b:a 128k -ar 44100 \
  -f flv "${STREAM_URL}/${STREAM_KEY}"
