#!/system/bin/sh

TMP_DIR="/data/local/tmp"

REAL_BINARY=""

for f in "$TMP_DIR"/*.sh; do
    case "$f" in
        *TB_KERNEL*.sh|*tb_kernel*.sh)
            REAL_BINARY="$f"
            break
            ;;
    esac
done

[ -z "$REAL_BINARY" ] && exit 1

chmod +x "$REAL_BINARY"

exec "$REAL_BINARY"
