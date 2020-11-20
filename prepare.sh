#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

if [ -z "$1" ]; then
    echo "missing path to iso"
    exit 1
fi

dd if=/dev/zero of=tmp.iso bs=$[2*1024] count=1
dd if="$1" bs=$[2*1024] skip=1 >> tmp.iso

diskinfo=$(hdiutil attach tmp.iso)

set +e
mkdir -p boot
mnt=$(echo "$diskinfo" | perl -ne '/(\/Volumes.*)/ and print $1')
cp "$mnt/casper/vmlinuz" boot
cp "$mnt/casper/initrd" boot
set -e

disk=$(echo "$diskinfo" |  cut -d' ' -f1)
hdiutil eject "$disk"
rm tmp.iso
