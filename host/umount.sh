#!/bin/sh

source config.sh

umount -l ${chroot_dir}/proc
umount -l ${chroot_dir}/sys

if mountpoint -q "${chroot_dir}"
then
    umount -l ${chroot_dir}
fi
