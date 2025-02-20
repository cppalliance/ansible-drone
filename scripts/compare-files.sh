#!/bin/bash

set -e

# Compare new drone server to original drone server.
# 

# Instructions:
# On each machine
# 
# vi /etc/ssh/sshd_config.d/70-sshfs.conf 
# 
# Match Address (ansible's host ip address)
#     PermitRootLogin yes
# 
# Then 'systemctl reload ssh'
# 
# Modify /root/.ssh/authorized_keys to remove the initial blocking messagaes
# 
# Run this command:
# ./compare-files.sh | tee /tmp/test.txt
#

touch /tmp/test.txt

unmount_commands="
fusermount3 -u /tmp/drone-original
fusermount3 -u /tmp/drone3
"

# testing
mount_commands="
sshfs root@drone.cpp.al:/ -o ro $src1
sshfs root@drone3.cpp.al:/ -o ro /tmp/drone3
"

src1="/tmp/drone-original"
src2="/tmp/drone3"

mkdir -p $src1
mkdir -p $src2

if [ ! -d $src1/var ]; then
    sshfs root@drone.cpp.al:/ -o ro $src1
fi

if [ ! -d $src2/var ]; then
    sshfs root@drone3.cpp.al:/ -o ro $src2
fi

directories="
/root/scripts
/var/lib/drone
/opt/drone/scripts
/var/lib/starlark
/var/spool/cron/crontabs
/etc/munin/plugins
/var/lib/postgresql/scripts
"

for dir in $directories; do
    echo "-------"
    echo "Compare $dir"
    echo "diff -r ${src1}${dir} ${src2}${dir}"
    echo "-------"
    diff -X .ignore-diff -r ${src1}${dir} ${src2}${dir} || true # don't exit if there's a diff
    echo " "
    echo " "
done

