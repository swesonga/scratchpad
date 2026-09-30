#!/usr/bin/env bash

usage() {
    cat <<EOF
Usage: $0 <commit>

Checks files in the specified Git commit for carriage return (CR) characters.

Arguments:
  <commit>      A Git commit, tag, branch, or other tree-ish to inspect.

Options:
  -h, --help    Display this help message.
EOF
}

if [ "$#" -ne 1 ]; then
    usage >&2
    exit 2
fi

case "$1" in
    -h|--help)
        usage
        exit 0
        ;;
esac

commit="$1"

if git grep -Il $'\r' "$commit" --; then
    echo "FAIL: CR characters found in $commit"
    exit 1
else
    rc=$?
    if [ "$rc" -eq 1 ]; then
        echo "PASS: no CR characters in $commit"
    else
        echo "ERROR: git grep failed with exit code $rc"
        exit "$rc"
    fi
fi
