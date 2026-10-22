import argparse
from zipfile import BadZipFile, ZipFile


def main() -> None:
    parser = argparse.ArgumentParser(
        description="List files in a ZIP archive from largest to smallest "
                    "by uncompressed size in bytes."
    )
    parser.add_argument("zip_path", help="Path to the ZIP file")
    args = parser.parse_args()

    try:
        with ZipFile(args.zip_path) as archive:
            files = sorted(
                (entry for entry in archive.infolist() if not entry.is_dir()),
                key=lambda entry: entry.file_size,
                reverse=True,
            )
    except (OSError, BadZipFile) as error:
        parser.error(str(error))

    for entry in files:
        print(f"{entry.file_size}\t{entry.filename}")


if __name__ == "__main__":
    main()
