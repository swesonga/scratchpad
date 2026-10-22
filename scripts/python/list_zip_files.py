import argparse
import sys
from zipfile import BadZipFile, ZipFile


def main() -> None:
    parser = argparse.ArgumentParser(
        description="List files in a ZIP archive from largest to smallest "
                    "by uncompressed size in bytes. Output uses UTF-8."
    )
    parser.add_argument("zip_path", help="Path to the ZIP file")
    parser.add_argument(
        "-n", "--limit", type=int, metavar="N",
        help="Display only the first N files (N must be non-negative; default: all)",
    )
    args = parser.parse_args()
    if args.limit is not None and args.limit < 0:
        parser.error("--limit must be non-negative")

    try:
        with ZipFile(args.zip_path) as archive:
            files = sorted(
                (entry for entry in archive.infolist() if not entry.is_dir()),
                key=lambda entry: entry.file_size,
                reverse=True,
            )
    except (OSError, BadZipFile) as error:
        parser.error(str(error))

    sys.stdout.reconfigure(encoding="utf-8")
    for entry in files[:args.limit]:
        print(f"{entry.file_size}\t{entry.filename}")


if __name__ == "__main__":
    main()
