#!/usr/bin/env python3
"""
Export every stash in a git repository to a patch file.
Each stash will be saved as 'stash-<N>.patch' in the current directory, where <N> is the stash index.
"""
import subprocess
import os
import sys
import re

def get_stash_list():
    result = subprocess.run(['git', 'stash', 'list'], stdout=subprocess.PIPE, text=True, check=True)
    stashes = []
    for line in result.stdout.splitlines():
        if line.startswith('stash@{'):
            stash_ref = line.split(':')[0]
            stashes.append(stash_ref)
    return stashes

def make_file_friendly_path(path):
    # Replace non-alphanumeric with underscores, collapse multiple underscores
    friendly = re.sub(r'[^A-Za-z0-9]+', '_', path)
    friendly = re.sub(r'_+', '_', friendly).strip('_')
    return friendly

def export_stash_patches(stashes, repo_root, full_path_in_name=False):
    prefix = ''
    if full_path_in_name:
        prefix = make_file_friendly_path(repo_root) + '_'
    for stash in stashes:
        idx = stash[7:-1]  # 'stash@{N}' -> N
        patch_file = f'{prefix}stash-{idx}.patch'
        with open(patch_file, 'w', encoding='utf-8') as f:
            subprocess.run(['git', 'stash', 'show', '-p', stash], stdout=f, check=True)
        print(f'Exported {stash} to {patch_file}')

def main():
    import argparse
    parser = argparse.ArgumentParser(description='Export every git stash to a patch file.')
    parser.add_argument('--full-path-in-name', action='store_true', help='Prepend a file-friendly version of the repo path to the stash patch file name.')
    args = parser.parse_args()

    repo_root = subprocess.run(['git', 'rev-parse', '--show-toplevel'], stdout=subprocess.PIPE, text=True, check=True).stdout.strip()
    os.chdir(repo_root)
    stashes = get_stash_list()
    if not stashes:
        print('No stashes found.')
        return
    export_stash_patches(stashes, repo_root, full_path_in_name=args.full_path_in_name)

if __name__ == '__main__':
    main()
