#!/usr/bin/env bash

usage() {
    cat <<EOF
Usage:
  $0 <commit>
  $0 --recent <count>

Checks files in a Git commit for carriage return (CR) characters. Inspect one
commit directly, or inspect a number of recent commits from newest to oldest.

Arguments:
  <commit>      A Git commit, tag, branch, or other tree-ish to inspect.
  <count>       A positive integer specifying how many commits to inspect.

Options:
  --recent      Inspect recent commits starting with HEAD.
  -h, --help    Display this help message.
EOF
}

check_commit() {
    local commit="$1"
    local rc

    if git grep -Il $'\r' "$commit" --; then
        echo "FAIL: CR characters found in $commit"
        return 1
    else
        rc=$?
        if [ "$rc" -eq 1 ]; then
            echo "PASS: no CR characters in $commit"
            return 0
        else
            echo "ERROR: git grep failed with exit code $rc"
            return "$rc"
        fi
    fi
}

if [ "$#" -eq 1 ] && { [ "$1" = "-h" ] || [ "$1" = "--help" ]; }; then
    usage
    exit 0
fi

if [ "$#" -eq 1 ]; then
    check_commit "$1"
    exit $?
fi

if [ "$#" -ne 2 ] || [ "$1" != "--recent" ]; then
    usage >&2
    exit 2
fi

count="$2"
if ! [[ "$count" =~ ^[1-9][0-9]*$ ]]; then
    echo "ERROR: count must be a positive integer." >&2
    usage >&2
    exit 2
fi

commits="$(git rev-list --max-count="$count" HEAD)"
rc=$?
if [ "$rc" -ne 0 ]; then
    echo "ERROR: unable to list recent commits." >&2
    exit "$rc"
fi

if [ -z "$commits" ]; then
    echo "ERROR: no commits found." >&2
    exit 1
fi

final_rc=0
while IFS= read -r commit; do
    check_commit "$commit"
    rc=$?

    if [ "$rc" -gt 1 ]; then
        final_rc="$rc"
    elif [ "$rc" -eq 1 ] && [ "$final_rc" -eq 0 ]; then
        final_rc=1
    fi
done <<< "$commits"

exit "$final_rc"
