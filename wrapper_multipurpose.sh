#!/system/bin/sh

TMP_DIR="/data/local/tmp"
MISC_DIR="/data/local/tmp/Zenko/miscellaneous"

# Parameters: wrapper.sh <sh_file_or_path> <config_file>
TARGET_SPEC="$1"
CONFIG_FILE="$2"

if [ -z "$TARGET_SPEC" ] || [ -z "$CONFIG_FILE" ]; then
    echo "Usage: wrapper.sh <sh_filename_or_path> <config_file>"
    exit 1
fi

REAL_BINARY=""

# Case 1: TARGET_SPEC is an absolute path that exists
if [ "${TARGET_SPEC#/}" != "$TARGET_SPEC" ] && [ -f "$TARGET_SPEC" ]; then
    REAL_BINARY="$TARGET_SPEC"
else
    # Case 2: treat as filename – search in known directories
    FILENAME="$TARGET_SPEC"
    for searchdir in "$TMP_DIR" "$MISC_DIR" /data/local/tmp/Zenko/*; do
        if [ -f "$searchdir/$FILENAME" ]; then
            REAL_BINARY="$searchdir/$FILENAME"
            break
        fi
    done
fi

if [ -z "$REAL_BINARY" ]; then
    echo "Error: $TARGET_SPEC not found"
    exit 1
fi

chmod +x "$REAL_BINARY"

# Find config file (unchanged)
if [ ! -f "$CONFIG_FILE" ]; then
    if [ -f "$TMP_DIR/$CONFIG_FILE" ]; then
        CONFIG_FILE="$TMP_DIR/$CONFIG_FILE"
    elif [ -f "/data/local/tmp/Zenko/$CONFIG_FILE" ]; then
        CONFIG_FILE="/data/local/tmp/Zenko/$CONFIG_FILE"
    else
        echo "Error: Config file not found"
        exit 1
    fi
fi

# Check if stdin exists (called from GUI)
if ! read -t 1 first_input 2>/dev/null; then
    # Probe mode - just run the script
    "$REAL_BINARY"
    exit 0
fi

# GUI input mode - pass input to script
INPUT="$first_input"
while read line; do
    INPUT="$INPUT
$line"
done

echo "$INPUT" | "$REAL_BINARY"