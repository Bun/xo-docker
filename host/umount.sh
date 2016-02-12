#!/bin/sh

set -e

source config.sh

mountpoint -q ${chroot_dir}/proc && umount -l ${chroot_dir}/proc
mountpoint -q ${chroot_dir}/sys && umount -l ${chroot_dir}/sys
mountpoint -q ${chroot_dir}/var/cache/apk && umount -l ${chroot_dir}/var/cache/apk
mountpoint -q ${chroot_dir} && umount -l ${chroot_dir}

true
