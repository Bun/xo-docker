#!/bin/sh

source config.sh

(echo "${mirror}latest-stable/main";
 echo "${mirror}latest-stable/community") > ${chroot_dir}/etc/apk/repositories

cp static/bootstrap.sh ${chroot_dir}/root/bootstrap.sh
chroot ${chroot_dir} /bin/sh /root/bootstrap.sh
rm ${chroot_dir}/root/bootstrap.sh

# TODO: replace with EC2-based config
mkdir -p ${chroot_dir}/root/.ssh
chmod 700 ${chroot_dir}/root/.ssh
cat /home/ben/.ssh/id_ed25519.pub > ${chroot_dir}/root/.ssh/authorized_keys

cp static/network ${chroot_dir}/etc/network/interfaces
cp static/modules ${chroot_dir}/etc/modules
cp static/motd    ${chroot_dir}/etc/motd

cp static/ec2-user-data ${chroot_dir}/etc/local.d/ec2-user-data.start
chmod +x ${chroot_dir}/etc/local.d/ec2-user-data.start
