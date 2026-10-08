#!/usr/bin/env bash

usage() {
    cat <<EOF
Usage:
  $0 [--modified-only] [--remove-cr] [--allow-untracked] <commit>
  $0 [--modified-only] [--remove-cr] [--allow-untracked] --recent <count>
  $0 --remove-cr-files <path>...

Checks files in a Git commit for carriage return (CR) characters. Inspect one
commit directly, or inspect a number of recent commits from newest to oldest.
By default, each commit's entire tree is checked.

Arguments:
  <commit>      A Git commit, tag, branch, or other tree-ish to inspect.
  <count>       A positive integer specifying how many commits to inspect.

Options:
  --modified-only  Check only files added or modified by each commit relative
                   to its first parent.
  --remove-cr      Remove CR characters from matching files in the current
                   worktree. Requires a clean worktree and index.
  --remove-cr-files
                   Remove CR characters from the supplied files without
                   requiring a Git repository. Shell-expanded full-path globs
                   are accepted, for example: --remove-cr-files /tmp/*.txt
  --allow-untracked
                   With --remove-cr, allow untracked files while still
                   rejecting staged or unstaged changes to tracked files.
  --recent         Inspect recent commits starting with HEAD.
  -h, --help       Display this help message.
EOF
}

check_commit() {
    local commit="$1"
    local parent
    local rc
    local record

    # Search committed blobs rather than worktree files so core.autocrlf and
    # other checkout conversions cannot alter the line endings being checked.
    # Keep \r as a textual PCRE escape: passing a literal CR with $'\r' through
    # MSYS can turn it into an empty argument, which makes git grep match every
    # text file instead of files that actually contain a carriage return.
    local -a grep_args=(-IlP '\r' "$commit" --)
    local -a collect_args=(-IlP -z '\r' "$commit" --)
    local -a modified_files=()
    local -a matched_records=()

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
        collect_args+=("${modified_files[@]}")
    fi

    if git -C "$repo_root" grep "${grep_args[@]}"; then
        if [ "$remove_cr" = true ]; then
            mapfile -d '' -t matched_records < <(
                git -C "$repo_root" grep "${collect_args[@]}"
            )
            for record in "${matched_records[@]}"; do
                removal_files["${record#"$commit:"}"]=1
            done
            echo "FOUND: CR characters in $commit"
        else
            echo "FAIL: CR characters found in $commit"
        fi
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
remove_cr=false
remove_cr_files=false
allow_untracked=false
recent_seen=false
arguments=()
declare -A removal_files=()

while [ "$#" -gt 0 ]; do
    case "$1" in
        -h|--help)
            usage
            exit 0
            ;;
        --modified-only)
            modified_only=true
            ;;
        --remove-cr)
            remove_cr=true
            ;;
        --remove-cr-files)
            mode="files"
            remove_cr_files=true
            ;;
        --allow-untracked)
            allow_untracked=true
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

if [ "$remove_cr_files" = true ]; then
    if [ "${#arguments[@]}" -eq 0 ]; then
        echo "ERROR: --remove-cr-files requires at least one file." >&2
        usage >&2
        exit 2
    fi

    if [ "$modified_only" = true ] || [ "$remove_cr" = true ] ||
        [ "$allow_untracked" = true ] || [ "$recent_seen" = true ]; then
        echo "ERROR: --remove-cr-files cannot be combined with Git checking options." >&2
        exit 2
    fi

    if ! command -v perl >/dev/null 2>&1; then
        echo "ERROR: --remove-cr-files requires perl." >&2
        exit 1
    fi

    declare -A filesystem_files=()
    for path in "${arguments[@]}"; do
        if [ ! -f "$path" ]; then
            echo "ERROR: file not found or not a regular file: $path" >&2
            exit 1
        fi
        filesystem_files["$path"]=1
    done

    perl -pi -e 's/\r//g' -- "${!filesystem_files[@]}"
    rc=$?
    if [ "$rc" -ne 0 ]; then
        echo "ERROR: failed to remove CR characters." >&2
        exit "$rc"
    fi

    echo "REMOVED: CR characters from ${#filesystem_files[@]} file(s)"
    exit 0
fi

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

if [ "$allow_untracked" = true ] && [ "$remove_cr" != true ]; then
    echo "ERROR: --allow-untracked requires --remove-cr." >&2
    exit 2
fi

repo_root="$(git rev-parse --show-toplevel)"
rc=$?
if [ "$rc" -ne 0 ]; then
    echo "ERROR: unable to determine the Git repository root." >&2
    exit "$rc"
fi

if [ "$remove_cr" = true ]; then
    untracked_mode=normal
    if [ "$allow_untracked" = true ]; then
        untracked_mode=no
    fi

    if [ -n "$(git -C "$repo_root" status --porcelain --untracked-files="$untracked_mode")" ]; then
        if [ "$allow_untracked" = true ]; then
            echo "ERROR: --remove-cr requires no staged or unstaged changes to tracked files." >&2
        else
            echo "ERROR: --remove-cr requires a clean worktree and index." >&2
        fi
        exit 1
    fi

    if ! command -v perl >/dev/null 2>&1; then
        echo "ERROR: --remove-cr requires perl." >&2
        exit 1
    fi
fi

if [ "$mode" = "commit" ]; then
    check_commit "$commit"
    final_rc=$?
else
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
fi

if [ "$remove_cr" = true ]; then
    if [ "$final_rc" -gt 1 ]; then
        exit "$final_rc"
    fi

    if [ "${#removal_files[@]}" -eq 0 ]; then
        echo "PASS: no CR characters to remove"
        exit 0
    fi

    for path in "${!removal_files[@]}"; do
        if [ ! -f "$repo_root/$path" ]; then
            echo "ERROR: matching worktree file not found: $path" >&2
            exit 1
        fi
    done

    (
        cd "$repo_root" || exit 1
        perl -pi -e 's/\r//g' -- "${!removal_files[@]}"
    )
    rc=$?
    if [ "$rc" -ne 0 ]; then
        echo "ERROR: failed to remove CR characters." >&2
        exit "$rc"
    fi

    echo "REMOVED: CR characters from ${#removal_files[@]} file(s)"
    exit 0
fi

exit "$final_rc"
