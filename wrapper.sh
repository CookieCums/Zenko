#!/system/bin/sh

TMP_DIR="/data/local/tmp"
MISC_DIR="/data/local/tmp/Zenko/miscellaneous"

TARGET_SPEC="$1"
CONFIG_FILE="$2"

rm -f /storage/emulated/0/*.h /storage/emulated/0/*.cfg 2>/dev/null

if [ -z "$TARGET_SPEC" ]; then
    echo "Usage: wrapper.sh <sh_filename_or_path> [config_file]"
    echo "       Use 'NO_CONFIG' or 'none' as second argument to skip config."
    exit 1
fi

CONFIG_REQUIRED=true
if [ -z "$CONFIG_FILE" ] || [ "$CONFIG_FILE" = "NO_CONFIG" ] || [ "$CONFIG_FILE" = "none" ]; then
    CONFIG_REQUIRED=false
fi

REAL_BINARY=""

if [ "${TARGET_SPEC#/}" != "$TARGET_SPEC" ] && [ -f "$TARGET_SPEC" ]; then
    REAL_BINARY="$TARGET_SPEC"
else
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

if [ "$CONFIG_REQUIRED" = true ]; then
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
fi

: $((ZENKO_BYPASS_ANTIDEBUG=1)) && export ZENKO_BYPASS_ANTIDEBUG



if ! read -t 1 first_input 2>/dev/null; then

    "$REAL_BINARY"
    exit 0
fi

INPUT="$first_input"
while read line; do
    INPUT="$INPUT
$line"
done

echo "$INPUT" | "$REAL_BINARY"
