#!/bin/sh
# 创建 1GB RAMDisk
ramfs_size_mb=512

# 挂载的卷名
volume_name="RAMDISK"

disk_size_mb2sector()
{
    local size_mb=$1
    echo $(($size_mb*1024*1024/512))
}

disk_create_ramdev()
{
    local ramfs_size=$1
    echo `/usr/bin/hdid -nomount ram://$ramfs_size`
}

disk_create_ramdisk()
{
    local volume_name=$1
    local ramfs_size=$2
    local ram_dev=`disk_create_ramdev $ramfs_size`
    /usr/sbin/diskutil quiet eraseVolume HFS+ "$volume_name" $ram_dev
    echo $ram_dev
}

# 计算 RAM 的扇区(Sector)大小
ramfs_size_sectors=`disk_size_mb2sector $ramfs_size_mb`

# 创建 RAM 卷并挂载
disk_create_ramdisk "$volume_name" $ramfs_size_sectors

# 下面的部分是创建 RAMDisk 的目录结构和需要的文件
# 因人而异可以自行增减
dir_list="Chromium Firefox Safari Safari/Meta Adium"

for dir in $dir_list
do
    /bin/mkdir -p "/Volumes/$volume_name/$dir"
done

