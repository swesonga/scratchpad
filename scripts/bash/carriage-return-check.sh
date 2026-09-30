#!/usr/bin/env bash

usage() {
    cat <<EOF
Usage:
  $0 [--modified-only] <commit>
  $0 [--modified-only] --recent <count>

Checks files in a Git commit for carriage return (CR) characters. Inspect one
commit directly, or inspect a number of recent commits from newest to oldest.
By default, each commit's entire tree is checked.

Arguments:
  <commit>      A Git commit, tag, branch, or other tree-ish to inspect.
  <count>       A positive integer specifying how many commits to inspect.

Options:
  --modified-only  Check only files added or modified by each commit relative
                   to its first parent.
  --recent         Inspect recent commits starting with HEAD.
  -h, --help       Display this help message.
EOF
}

check_commit() {
    local commit="$1"
    local parent
    local rc

    # Search committed blobs rather than worktree files so core.autocrlf and
    # other checkout conversions cannot alter the line endings being checked.
    # Keep \r as a textual PCRE escape: passing a literal CR with $'\r' through
    # MSYS can turn it into an empty argument, which makes git grep match every
    # text file instead of files that actually contain a carriage return.
    local -a grep_args=(-IlP '\r' "$commit" --)
    local -a modified_files=()

    git -C "$repo_root" rev-parse --verify --quiet "$commit^{commit}" >/dev/null
    rc=$?
    if [ "$rc" -ne 0 ]; then
        echo "ERROR: invalid commit: $commit" >&2
        return "$rc"
    fi

    if [ "$modified_only" = true ]; then
        parent="$(git -C "$repo_root" rev-parse --verify --quiet "$commit^1")"

        # Git paths may contain newline characters, so emit NUL-delimited paths
        # with -z and have mapfile split only on NUL rather than on newlines.
        if [ -n "$parent" ]; then
            mapfile -d '' -t modified_files < <(
                git -C "$repo_root" diff-tree --no-commit-id --name-only \
                    --diff-filter=ACMRTUXB -r -z "$parent" "$commit"
            )
        else
            mapfile -d '' -t modified_files < <(
                git -C "$repo_root" ls-tree -r --name-only -z "$commit"
            )
        fi

        if [ "${#modified_files[@]}" -eq 0 ]; then
            echo "PASS: no eligible modified files in $commit"
            return 0
        fi

        grep_args+=("${modified_files[@]}")
    fi

    if git -C "$repo_root" grep "${grep_args[@]}"; then
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

mode="commit"
modified_only=false
recent_seen=false
arguments=()

while [ "$#" -gt 0 ]; do
    case "$1" in
        -h|--help)
            usage
            exit 0
            ;;
        --modified-only)
            modified_only=true
            ;;
        --recent)
            if [ "$recent_seen" = true ]; then
                echo "ERROR: --recent may only be specified once." >&2
                exit 2
            fi
            mode="recent"
            recent_seen=true
            ;;
        --)
            shift
            arguments+=("$@")
            break
            ;;
        -*)
            echo "ERROR: unknown option: $1" >&2
            usage >&2
            exit 2
            ;;
        *)
            arguments+=("$1")
            ;;
    esac
    shift
done

if [ "${#arguments[@]}" -ne 1 ]; then
    usage >&2
    exit 2
fi

if [ "$mode" = "recent" ]; then
    count="${arguments[0]}"
    if ! [[ "$count" =~ ^[1-9][0-9]*$ ]]; then
        echo "ERROR: count must be a positive integer." >&2
        usage >&2
        exit 2
    fi
else
    commit="${arguments[0]}"
fi

repo_root="$(git rev-parse --show-toplevel)"
rc=$?
if [ "$rc" -ne 0 ]; then
    echo "ERROR: unable to determine the Git repository root." >&2
    exit "$rc"
fi

if [ "$mode" = "commit" ]; then
    check_commit "$commit"
    exit $?
fi

commits="$(git -C "$repo_root" rev-list --max-count="$count" HEAD)"
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
