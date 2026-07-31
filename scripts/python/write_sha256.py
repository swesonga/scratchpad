import os
import sys
import hashlib

def compute_sha256(filepath):
    sha256 = hashlib.sha256()
    with open(filepath, "rb") as f:
        for chunk in iter(lambda: f.read(8192), b""):
            sha256.update(chunk)
    return sha256.hexdigest()

import time
from datetime import datetime

def process_per_file(directory, force=False):
    for root, _, files in os.walk(directory):
        for filename in sorted(files):
            if filename.endswith(".sha256.txt"):
                continue
            filepath = os.path.join(root, filename)
            hashfile = filepath + ".sha256.txt"
            if os.path.exists(hashfile) and not force:
                continue  # Skip if hash file already exists unless force is set
            start_time = time.time()
            now_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            print(f"[{now_time}] Processing: {filepath}")
            sha256sum = compute_sha256(filepath)
            with open(hashfile, "w") as f:
                f.write(sha256sum + "\n")
            end_time = time.time()
            duration = end_time - start_time
            now_time_end = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            print(f"[{now_time_end}]    Digest: {sha256sum} (Duration: {duration:.2f}s)")


def process_concat(directory, concat_hashes, force=False):
    concat_path = os.path.join(directory, concat_hashes)
    if os.path.exists(concat_path) and not force:
        print(f"{concat_path} already exists; use --force to overwrite.")
        return
    with open(concat_path, "w", encoding="utf-8") as concat_file:
        for root, _, files in os.walk(directory):
            for filename in sorted(files):
                if filename.endswith(".sha256.txt"):
                    continue
                filepath = os.path.join(root, filename)
                if os.path.abspath(filepath) == os.path.abspath(concat_path):
                    continue
                start_time = time.time()
                now_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                print(f"[{now_time}] Processing: {filepath}")
                sha256sum = compute_sha256(filepath)
                relpath = os.path.relpath(filepath, directory)
                concat_file.write(f"{sha256sum}  {relpath}\n")
                end_time = time.time()
                duration = end_time - start_time
                now_time_end = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                print(f"[{now_time_end}]    Digest: {sha256sum} (Duration: {duration:.2f}s)")

    # Write the digest of the concatenated hash file itself
    digest = compute_sha256(concat_path)
    digest_file = concat_path + ".sha256.txt"
    with open(digest_file, "w") as f:
        f.write(digest + "\n")
    print(f"Wrote combined hashes to {concat_path}")
    print(f"Wrote digest of combined file to {digest_file}: {digest}")

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description="Write SHA256 hashes for files in a directory.")
    parser.add_argument("directory", help="Directory to process")
    parser.add_argument("-f", "--force", action="store_true", help="Overwrite existing .sha256.txt files")
    parser.add_argument("--concat-hashes", nargs="?", const="hashes.sha256.txt", default=None,
                        metavar="FILENAME",
                        help="Write all hashes to a single file (default: hashes.sha256.txt) "
                             "instead of one file per input, then write its digest to a separate file")
    args = parser.parse_args()
    if args.concat_hashes:
        process_concat(args.directory, args.concat_hashes, force=args.force)
    else:
        process_per_file(args.directory, force=args.force)
