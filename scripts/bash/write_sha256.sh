#!/usr/bin/env bash
# write_sha256.sh
# Usage: ./write_sha256.sh <directory>

dir="$1"

set -e

force=0
while getopts "f" opt; do
  case $opt in
    f)
      force=1
      ;;
    *)
      echo "Usage: $0 [-f] <directory>"
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))

dir="$1"

if [ -z "$dir" ]; then
  echo "Usage: $0 [-f] <directory>"
  exit 1
fi

find "$dir" -type f ! -name '*.sha256.txt' | while read -r file; do
  hashfile="$file.sha256.txt"
  if [ -e "$hashfile" ] && [ "$force" -ne 1 ]; then
    continue
  fi
  start_time=$(date +%s)
  now_time=$(date '+%Y-%m-%d %H:%M:%S')
  echo "[$now_time] Processing: $file"
  # Use awk to extract only the hash (first field) from shasum output
  hash=$(shasum -a 256 "$file" | awk '{print $1}')
  echo "$hash" > "$hashfile"
  end_time=$(date +%s)
  duration=$((end_time - start_time))
  now_time_end=$(date '+%Y-%m-%d %H:%M:%S')
  echo "[$now_time_end] Finished: $hash (Duration: ${duration}s)"
done
