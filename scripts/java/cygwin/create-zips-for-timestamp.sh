#!/bin/bash

set -e

function log_message()
{
    current_time=`date +%Y-%m-%d%t%H:%M:%S`
    echo "$current_time $1"
}

function print_usage()
{
    echo "Usage: create-zips-for-timestamp.sh --os <os> --arch <architecture> --debug-level <debug_level> --variant <variant> --timestamp <timestamp>"
}

os=""
arch=""
debug_level=""
variant=""
timestamp=""

while [ $# -gt 0 ]; do
    opt="$1"
    case "$opt" in
        --os|--arch|--architecture|--debug-level|--variant|--timestamp)
            if [ $# -lt 2 ]; then
                echo "Error: option '$opt' requires a value." >&2
                print_usage
                exit 1
            fi
            val="$2"
            shift 2
            case "$opt" in
                --os)                  os="$val";;
                --arch|--architecture) arch="$val";;
                --debug-level)         debug_level="$val";;
                --variant)             variant="$val";;
                --timestamp)           timestamp="$val";;
            esac
            ;;
        -h|--help)
            print_usage
            exit 0
            ;;
        *)
            echo "Unknown option: $opt" >&2
            print_usage
            exit 1
            ;;
    esac
done

if [ -z "$os" ] || [ -z "$arch" ] || [ -z "$debug_level" ] || [ -z "$variant" ] || [ -z "$timestamp" ]; then
    echo "Error: --os, --arch, --debug-level, --variant, and --timestamp are required." >&2
    print_usage
    exit 1
fi

build_conf="${os}-${arch}-${variant}-${debug_level}"
build_conf_dir="build/${build_conf}"
built_jdk="${build_conf_dir}/images/jdk"
git_hash=$(git rev-parse --short HEAD)

images_zip="${build_conf}-${git_hash}-${timestamp}-jdk.zip"
support_test_zip="${build_conf}-${git_hash}-${timestamp}-support-test.zip"
images_test_zip="${build_conf}-${git_hash}-${timestamp}-images-test.zip"

for required_dir in "$built_jdk" "${build_conf_dir}/images/test" "${build_conf_dir}/support/test"; do
    if [ ! -d "$required_dir" ]; then
        echo "Error: required build directory does not exist: $required_dir" >&2
        exit 1
    fi
done

git log -10 > "${built_jdk}/repo_info.txt"
git status >> "${built_jdk}/repo_info.txt"
git diff > "${built_jdk}/repo_diff.txt"

log_message "Zipping the JDK in $built_jdk into $images_zip"
(
    cd "$built_jdk"
    zip -qru "$images_zip" .
    if [ -d "$JDK_ZIP_DEST" ]; then
        log_message "Copying $images_zip to $JDK_ZIP_DEST"
        cp "$images_zip" "$JDK_ZIP_DEST"
    fi
    mv "$images_zip" ../..
)

log_message "Zipping images/test into $images_test_zip"
(
    cd "$build_conf_dir"
    zip -qru "$images_test_zip" images/test
    if [ -d "$JDK_ZIP_DEST" ]; then
        log_message "Copying $images_test_zip to $JDK_ZIP_DEST"
        cp "$images_test_zip" "$JDK_ZIP_DEST"
    fi
)

log_message "Zipping support/test into $support_test_zip"
(
    cd "$build_conf_dir"
    zip -qru "$support_test_zip" support/test
)

log_message "Zip creation complete"