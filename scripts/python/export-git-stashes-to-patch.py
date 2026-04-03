#!/usr/bin/env python3
"""
Export every stash in a git repository to a patch file.
Each stash will be saved as 'stash-<N>.patch' in the current directory, where <N> is the stash index.
"""
import subprocess
import os
import sys

def get_stash_list():
    result = subprocess.run(['git', 'stash', 'list'], stdout=subprocess.PIPE, text=True, check=True)
    stashes = []
    for line in result.stdout.splitlines():
        if line.startswith('stash@{'):
            stash_ref = line.split(':')[0]
            stashes.append(stash_ref)
    return stashes

def export_stash_patches(stashes):
    for stash in stashes:
        idx = stash[6:-1]  # Extract the number from 'stash@{N}'
        patch_file = f'stash-{idx}.patch'
        with open(patch_file, 'w', encoding='utf-8') as f:
            subprocess.run(['git', 'stash', 'show', '-p', stash], stdout=f, check=True)
        print(f'Exported {stash} to {patch_file}')

def main():
    repo_root = subprocess.run(['git', 'rev-parse', '--show-toplevel'], stdout=subprocess.PIPE, text=True, check=True).stdout.strip()
    os.chdir(repo_root)
    stashes = get_stash_list()
    if not stashes:
        print('No stashes found.')
        return
    export_stash_patches(stashes)

if __name__ == '__main__':
    main()
