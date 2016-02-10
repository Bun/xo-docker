#!/bin/sh
set -e

source config.sh

if ! mountpoint -q "${chroot_dir}"
then
    mount -o loop "${fs}" "${chroot_dir}"
fi

mount -t proc none ${chroot_dir}/proc
mount -o bind /sys ${chroot_dir}/sys
