#!/system/bin/sh

VARIANTS="
com.tencent.ig
com.pubg.krmobile
com.pubg.imobile
com.vng.pubgmobile
com.rekoo.pubgm
"

nsenter --mount=/proc/1/ns/mnt -- sh -c "
    setenforce 0
    for pkg in $VARIANTS; do
        # Check if package exists before attempting to delete
        if [ -d \"/data/data/\$pkg\" ]; then
            echo \"Cleaning data for: \$pkg\"
            rm -rf \"/data/data/\$pkg/databases/\"
            rm -rf \"/data/data/\$pkg/shared_prefs/\"
        else
            echo \"Package not found: \$pkg\"
        fi
    done
    setenforce 1
"
echo "Done"
