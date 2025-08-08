#!/usr/bin/env python3
"""
Script to process test files and extract sections containing "test jdk:" text.

For each text file in a specified folder:
- Split into sections using "--------------------------------------------------" as separator
- Generate filename from first line after separator (text after "TEST: ")
- If section contains "test jdk:" then write the entire section to a file
"""

import os
import sys
import re
from pathlib import Path


def sanitize_filename(filename):
    """
    Sanitize filename by replacing /, #, and . with underscores and adding .txt extension.
    
    Args:
        filename (str): The original filename
        
    Returns:
        str: Sanitized filename with .txt extension
    """
    # Replace /, #, and . with underscores
    sanitized = filename.replace('/', '_').replace('#', '_').replace('.', '_')
    # Add .txt extension
    return f"{sanitized}.txt"


def extract_test_name(line):
    """
    Extract test name from a line containing "TEST: ".
    
    Args:
        line (str): Line containing test information
        
    Returns:
        str or None: Test name if found, None otherwise
    """
    # Look for "TEST: " in the line
    test_match = re.search(r'TEST:\s*(.+)', line)
    if test_match:
        return test_match.group(1).strip()
    return None


def process_file(input_file_path, output_dir):
    """
    Process a single text file and extract sections containing "test jdk:".
    
    Args:
        input_file_path (Path): Path to input file
        output_dir (Path): Directory to write output files
    """
    try:
        with open(input_file_path, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
    except Exception as e:
        print(f"Error reading file {input_file_path}: {e}")
        return
    
    # Split content by separator
    sections = content.split('--------------------------------------------------')
    
    processed_sections = 0
    
    for i, section in enumerate(sections):
        if not section.strip():
            continue
            
        # Check if section contains "test jdk:" (case insensitive)
        if 'test jdk:' not in section.lower():
            continue
            
        # Get lines of the section
        lines = section.strip().split('\n')
        
        # Find the first line with "TEST: "
        test_name = None
        for line in lines:
            test_name = extract_test_name(line)
            if test_name:
                break
        
        if not test_name:
            print(f"Warning: No TEST: line found in section {i} of {input_file_path}")
            continue
        
        # Generate filename
        output_filename = sanitize_filename(test_name)
        output_file_path = output_dir / output_filename
        
        # Reconstruct the full section with separators
        full_section = '--------------------------------------------------\n' + section
        if i < len(sections) - 1:  # Add trailing separator if not the last section
            full_section += '\n--------------------------------------------------'
        
        # Write the section to file
        try:
            with open(output_file_path, 'w', encoding='utf-8') as f:
                f.write(full_section)
            print(f"Extracted: {test_name} -> {output_filename}")
            processed_sections += 1
        except Exception as e:
            print(f"Error writing file {output_file_path}: {e}")
    
    print(f"Processed {processed_sections} sections from {input_file_path.name}")


def main():
    """Main function to process all text files in a user-specified folder."""
    
    # Get input folder from user
    if len(sys.argv) > 1:
        input_folder = sys.argv[1]
    else:
        input_folder = input("Enter the path to the folder containing text files: ").strip()
    
    input_path = Path(input_folder)
    
    if not input_path.exists():
        print(f"Error: Folder '{input_folder}' does not exist.")
        return
    
    if not input_path.is_dir():
        print(f"Error: '{input_folder}' is not a directory.")
        return
    
    # Create output directory
    output_dir = input_path / "extracted_sections"
    output_dir.mkdir(exist_ok=True)
    print(f"Output directory: {output_dir}")
    
    # Find all text files
    text_files = list(input_path.glob("*.txt"))
    
    if not text_files:
        print(f"No .txt files found in {input_folder}")
        return
    
    print(f"Found {len(text_files)} text files to process...")
    
    # Process each file
    total_processed = 0
    for text_file in text_files:
        print(f"\nProcessing: {text_file.name}")
        process_file(text_file, output_dir)
        total_processed += 1
    
    print(f"\nCompleted processing {total_processed} files.")
    print(f"Extracted sections saved to: {output_dir}")


if __name__ == "__main__":
    main()
