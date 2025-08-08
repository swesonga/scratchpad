# Test File Processor

This Python script processes text files containing test results and extracts sections that contain "test jdk:" information.

## Features

- Processes all `.txt` files in a specified folder
- Splits files into sections using `--------------------------------------------------` as separator
- Extracts test name from lines containing `TEST: `
- Generates safe filenames by replacing `/`, `#`, and `.` with underscores
- Only saves sections that contain "test jdk:" (case-insensitive)
- Preserves the complete section content with separators

## Usage

### Command Line
```bash
python process_test_files.py <folder_path>
```

### Interactive Mode
```bash
python process_test_files.py
```
Then enter the folder path when prompted.

## Example

```bash
python process_test_files.py "c:\path\to\test\files"
```

This will:
1. Process all `.txt` files in the specified folder
2. Create an `extracted_sections` subfolder
3. Extract sections containing "test jdk:" to individual files
4. Display progress and summary information

## Output

- Extracted files are saved to `extracted_sections/` subfolder
- Filenames are generated from the TEST: line (e.g., `java/lang/ProcessBuilder/Basic.java#id0` becomes `java_lang_ProcessBuilder_Basic_java_id0.txt`)
- Each file contains the complete section with separators

## Requirements

- Python 3.6 or higher
- No external dependencies required (uses only standard library)
