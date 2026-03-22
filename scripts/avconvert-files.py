#!/usr/bin/env python3
"""Batch convert .mov files to 1080p using macOS avconvert.

Prompt:
Write a python program that runs avconvert on all the .mov files in a directory. It should
- convert each file to a 1080p file
- append the "-1080p" suffix to the file name
- ask the user whether to continue after 10 files have been processed

Prompt 2:
display how long each avconvert call takes

Prompt 3:
display the current time in addition to the elapsed time
"""

import argparse
from datetime import datetime
import subprocess
import sys
import time
from pathlib import Path


def convert_file(src: Path, dst: Path) -> bool:
    cmd = [
        "avconvert",
        "--source", str(src),
        "--output", str(dst),
        "--preset", "Preset1920x1080",
    ]
    print(f"Converting: {src.name} -> {dst.name}")
    start = time.monotonic()
    result = subprocess.run(cmd)
    elapsed = time.monotonic() - start
    now = datetime.now().strftime("%H:%M:%S")
    if result.returncode != 0:
        print(f"  ERROR: avconvert exited with code {result.returncode} ({elapsed:.1f}s) [{now}]", file=sys.stderr)
        return False
    print(f"  Done in {elapsed:.1f}s [{now}]")
    return True


def main():
    parser = argparse.ArgumentParser(description="Convert .mov files to 1080p using avconvert")
    parser.add_argument("directory", nargs="?", default=".",
                        help="Directory containing .mov files (default: current directory)")
    parser.add_argument("--dry-run", action="store_true",
                        help="List files that would be converted without converting")
    args = parser.parse_args()

    directory = Path(args.directory).resolve()
    if not directory.is_dir():
        print(f"Error: {directory} is not a directory", file=sys.stderr)
        sys.exit(1)

    mov_files = sorted(directory.glob("*.mov"))
    # Exclude files that already have the -1080p suffix
    mov_files = [f for f in mov_files if not f.stem.endswith("-1080p")]

    if not mov_files:
        print("No .mov files found to convert.")
        sys.exit(0)

    print(f"Found {len(mov_files)} .mov file(s) in {directory}\n")

    if args.dry_run:
        for f in mov_files:
            dst = f.with_stem(f.stem + "-1080p")
            print(f"  {f.name} -> {dst.name}")
        sys.exit(0)

    converted = 0
    failed = 0

    for i, src in enumerate(mov_files, start=1):
        dst = src.with_stem(src.stem + "-1080p")
        if dst.exists():
            print(f"Skipping {src.name}: {dst.name} already exists")
            continue

        if convert_file(src, dst):
            converted += 1
        else:
            failed += 1

        # After every 5 processed files, ask to continue
        if i % 5 == 0 and i < len(mov_files):
            remaining = len(mov_files) - i
            answer = input(f"\nProcessed {i} files ({remaining} remaining). Continue? [Y/n] ").strip().lower()
            if answer in ("n", "no"):
                print("Stopping.")
                break
            print()

    print(f"\nDone. Converted: {converted}, Failed: {failed}, "
          f"Total processed: {converted + failed}/{len(mov_files)}")


if __name__ == "__main__":
    main()
