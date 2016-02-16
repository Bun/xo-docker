#!/bin/sh

source config.sh

(echo "${mirror}latest-stable/main";
 echo "${mirror}latest-stable/community") > ${chroot_dir}/etc/apk/repositories

# TODO: replace with EC2-based config
mkdir -p ${chroot_dir}/root/.ssh
chmod 700 ${chroot_dir}/root/.ssh
cat /home/ben/.ssh/id_ed25519.pub > ${chroot_dir}/root/.ssh/authorized_keys

rsync -av --no-owner --no-group overlay/ ${chroot_dir}/
chroot ${chroot_dir} /bin/sh /root/bootstrap.sh
rm ${chroot_dir}/root/bootstrap.sh
