#!/bin/sh
set -e

source config.sh

apk_cache_dir="apk-cache"
chroot_apk_cache="${chroot_dir}/var/cache/apk"


mountpoint -q "${chroot_dir}"       || mount -o loop "${fs}" "${chroot_dir}"
mountpoint -q "${chroot_apk_cache}" || mount -o bind "${apk_cache_dir}" "${chroot_apk_cache}"

mountpoint -q "${chroot_dir}/proc" || mount -t proc none ${chroot_dir}/proc
mountpoint -q "${chroot_dir}/sys"  || mount -o bind /sys ${chroot_dir}/sys
