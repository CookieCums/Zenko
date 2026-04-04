nsenter --mount=/proc/1/ns/mnt -- sh -c "
    setenforce 0
    rm -rf /data/data/com.pubg.imobile/databases/
    rm -rf /data/data/com.pubg.imobile/shared_prefs/
    setenforce 1
"
echo "Done"
