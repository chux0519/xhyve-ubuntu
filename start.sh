#!/usr/bin/env bash

set -eox pipefail
IFS=$'\n\t'

if [ "$(whoami)" != "root" ]; then
    echo "missing sudo"
    exit 1
fi

memgb=2
cpus=1

xhyve \
    -A \
	-U "5142aefe-220f-4e9a-9bb3-ee09b7214688" \
    -c "$cpus" \
    -m "${memgb}G" \
    -s 0,hostbridge \
    -s 2,virtio-net \
    -s 4,virtio-blk,storage.img \
    -s 31,lpc \
    -l com1,stdio \
	-f "kexec,boot/vmlinuz-5.4.0-54-generic,boot/initrd.img-5.4.0-54-generic,earlyprintk=serial console=ttyS0 root=/dev/vda2 ro systemd.unified_cgroup_hierarchy=1"
