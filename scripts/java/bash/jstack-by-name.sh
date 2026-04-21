#!/usr/bin/env bash
set -euo pipefail

usage() {
    echo "Usage: $(basename "$0") <JAVA_HOME> <name>"
    echo ""
    echo "  JAVA_HOME  Path to a JDK installation"
    echo "  name       Process name (or substring) to match in jps -l output"
    exit 1
}

if [[ $# -ne 2 ]]; then
    usage
fi

JAVA_HOME="$1"
NAME="$2"

JPS="$JAVA_HOME/bin/jps"
JSTACK="$JAVA_HOME/bin/jstack"

if [[ ! -x "$JPS" ]]; then
    echo "Error: jps not found or not executable at $JPS" >&2
    exit 1
fi

if [[ ! -x "$JSTACK" ]]; then
    echo "Error: jstack not found or not executable at $JSTACK" >&2
    exit 1
fi

# Run jps -l and find the first line matching the user-specified name
MATCH=$("$JPS" -l | grep -i "$NAME" | head -n 1)

if [[ -z "$MATCH" ]]; then
    echo "Error: no process matching '$NAME' found in jps -l output" >&2
    exit 1
fi

PID=$(echo "$MATCH" | awk '{print $1}')
PROCESS_NAME=$(echo "$MATCH" | awk '{$1=""; print substr($0,2)}')

echo "Matched process: PID=$PID  Name=$PROCESS_NAME"

OUTPUT_FILE="jstack_l_${PID}.txt"

echo "Running: $JSTACK -l $PID > $OUTPUT_FILE"
"$JSTACK" -l "$PID" > "$OUTPUT_FILE" 2>&1

echo "Output written to $OUTPUT_FILE"
