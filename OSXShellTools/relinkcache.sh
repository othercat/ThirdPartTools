#!/bin/sh

OLD_PWD=`pwd`
CACHE_DISK="/Volumes/RAMDISK"
USER_DIR="/Users/lirichard"
DO_RESTORE=0

if [ ! -z $1 ]; then
    case "$1" in
        "restore")
            DO_RESTORE=1
            echo "In the restore mode."
            ;;
        "help")
            echo "Usage:\n\n    ${0##*/} {move|restore|help} [path_to_cache_disk]\n"
            exit 1
            ;;
    esac
fi

if [ ! -z $2 ] && [ -d $2 ]; then
    CACHE_DISK=$2
fi

cache_link()
{
    local source=$1
    local target=$2
    local restore=$3
    local source_dir=${source%/*}
    local source_name=${source##*/}
    local create_cmd=""
    if [ -f "$source" ]; then
        create_cmd=/usr/bin/touch
    elif [ -d "$source" ]; then
        create_cmd="/bin/mkdir -p"
    fi

    if [ -d "$source_dir" ]; then
        cd "$source_dir"
        echo cd to $source_dir
    fi

    echo "Source name is '$source_name'"

    if [ -L "$source_name" ]; then
        /bin/rm "$source_name"
        # echo "Removed '$source_name'"
    fi

    local disk_cache=$source_name.DISK
    local ram_cache=$source_name.RAM

    if [ ! -e "$disk_cache" ]; then
        echo Moving the disk cache "$disk_cache" ...
        /bin/mv "$source_name" "$disk_cache"
    fi

    if [ ! -e "$ram_cache" ]; then
        echo Making the ram cache "$ram_cache" from $target ...
        if [ ! -e "$target" ]; then
            echo "    $create_cmd $target"
            $create_cmd "$target"
        fi
        /bin/ln -s "$target" "$ram_cache"
    fi

    if [[ $restore -eq 1 ]]; then
        /bin/ln -s "$disk_cache" "$source_name"
        echo "The cache $source was restored.\n"
    else
        /bin/ln -s "$ram_cache" "$source_name"
        echo "The cache $source -> $target was maked.\n"
    fi

    cd $OLD_PWD
}

LIBDIR="$USER_DIR/Library"

# Chromium
cache_link "$LIBDIR/Caches/Chromium/Default/Cache" "$CACHE_DISK/Chromium" $DO_RESTORE
# Adium
cache_link "$LIBDIR/Caches/Adium/Default" "$CACHE_DISK/Adium" $DO_RESTORE
# Firefox
cache_link "$LIBDIR/Caches/Firefox/Profiles/zvo4xhu9.default/Cache" "$CACHE_DISK/Firefox" $DO_RESTORE
# Safari
cache_link "$LIBDIR/Caches/com.apple.Safari" "$CACHE_DISK/Safari" $DO_RESTORE
# Safari Web Preview
cache_link "$LIBDIR/Caches/Metadata/Safari" "$CACHE_DISK/Safari/Meta" $DO_RESTORE
