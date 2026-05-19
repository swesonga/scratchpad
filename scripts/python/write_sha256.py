import os
import sys
import hashlib

def compute_sha256(filepath):
    sha256 = hashlib.sha256()
    with open(filepath, "rb") as f:
        for chunk in iter(lambda: f.read(8192), b""):
            sha256.update(chunk)
    return sha256.hexdigest()

def main(directory):
    for root, _, files in os.walk(directory):
        for filename in files:
            if not filename.endswith(".sha256.txt"):
                filepath = os.path.join(root, filename)
                hashfile = filepath + ".sha256.txt"
                if os.path.exists(hashfile):
                    continue  # Skip if hash file already exists
                sha256sum = compute_sha256(filepath)
                with open(hashfile, "w") as f:
                    f.write(sha256sum + "\n")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python write_sha256.py <directory>")
        sys.exit(1)
    main(sys.argv[1])
