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

def main(directory, force=False):
    for root, _, files in os.walk(directory):
        for filename in sorted(files):
            if not filename.endswith(".sha256.txt"):
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
                print(f"[{now_time_end}] Finished: {sha256sum} (Duration: {duration:.2f}s)")

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description="Write SHA256 hashes for files in a directory.")
    parser.add_argument("directory", help="Directory to process")
    parser.add_argument("-f", "--force", action="store_true", help="Overwrite existing .sha256.txt files")
    args = parser.parse_args()
    main(args.directory, force=args.force)
