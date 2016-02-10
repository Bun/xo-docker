#!/bin/sh

set -e

source config.sh

echo "Creating filesystem"

if test -e "${fs}"
then
    rm "${fs}"
fi

truncate -s "${size}" "${fs}"
mkfs.ext4 -F "${fs}"

rm -rf "${chroot_dir}"
mkdir "${chroot_dir}"


echo "Mounting base image"

mount -o loop "${fs}" "${chroot_dir}"


echo "Downloading apk-tools"

wget -N "${mirror}/latest-stable/main/x86_64/apk-tools-static-${version}.apk"
tar xf apk-tools-static-*.apk


./sbin/apk.static -X ${mirror}/latest-stable/main -U --allow-untrusted --root ${chroot_dir} --initdb add alpine-base openssh

echo "Preparing /dev"

mknod -m 666 ${chroot_dir}/dev/full c 1 7
mknod -m 666 ${chroot_dir}/dev/ptmx c 5 2
mknod -m 644 ${chroot_dir}/dev/random c 1 8
mknod -m 644 ${chroot_dir}/dev/urandom c 1 9
mknod -m 666 ${chroot_dir}/dev/zero c 1 5
mknod -m 666 ${chroot_dir}/dev/tty c 5 0

echo "Preparing /etc"

cp /etc/resolv.conf ${chroot_dir}/etc/
mkdir -p ${chroot_dir}/root

mkdir -p ${chroot_dir}/etc/apk
echo "${mirror}/${branch}/main" > ${chroot_dir}/etc/apk/repositories

echo "Done"
