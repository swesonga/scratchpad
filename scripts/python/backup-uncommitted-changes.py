#!/usr/bin/env python3
"""
Backup untracked and modified files in a git repository.
Creates a timestamped zip archive containing all uncommitted (untracked and modified) files.
"""
import subprocess
import os
import sys
import zipfile
from datetime import datetime


def get_uncommitted_files():
    """Return a list of untracked and modified files in the git repo."""
    # Get modified (unstaged + staged) and untracked files
    result = subprocess.run([
        'git', 'status', '--porcelain'
    ], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, check=True)
    files = []
    for line in result.stdout.splitlines():
        status, path = line[:2], line[3:]
        if status.strip() in {'M', 'A', 'D', 'R', 'C', 'U', '??'} or status.startswith('??'):
            files.append(path)
    return files

def create_backup(files, repo_root):
    if not files:
        print('No uncommitted files to back up.')
        return None
    timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    backup_name = f'git-backup-{timestamp}.zip'
    backup_path = os.path.join(repo_root, backup_name)
    with zipfile.ZipFile(backup_path, 'w', zipfile.ZIP_DEFLATED) as zf:
        for file in files:
            abs_path = os.path.join(repo_root, file)
            if os.path.isfile(abs_path):
                zf.write(abs_path, arcname=file)
    print(f'Backup created: {backup_path}')
    return backup_path

def main():
    repo_root = subprocess.run(['git', 'rev-parse', '--show-toplevel'], stdout=subprocess.PIPE, text=True, check=True).stdout.strip()
    os.chdir(repo_root)
    files = get_uncommitted_files()
    create_backup(files, repo_root)

if __name__ == '__main__':
    main()
