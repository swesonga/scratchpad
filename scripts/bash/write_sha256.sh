#!/usr/bin/env bash
# write_sha256.sh
# Usage: ./write_sha256.sh <directory>

set -e

dir="$1"

if [ -z "$dir" ]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

find "$dir" -type f ! -name '*.sha256.txt' | while read -r file; do
  hashfile="$file.sha256.txt"
  if [ -e "$hashfile" ]; then
    continue
  fi
  # Use awk to extract only the hash (first field) from shasum output
  shasum -a 256 "$file" | awk '{print $1}' > "$hashfile"
done
