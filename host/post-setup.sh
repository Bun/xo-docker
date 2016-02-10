#!/bin/sh

chroot alpine /sbin/rc-update add devfs sysinit
chroot alpine /sbin/rc-update add dmesg sysinit
chroot alpine /sbin/rc-update add mdev sysinit

chroot alpine /sbin/rc-update add hwclock boot
chroot alpine /sbin/rc-update add modules boot
chroot alpine /sbin/rc-update add sysctl boot
chroot alpine /sbin/rc-update add hostname boot
chroot alpine /sbin/rc-update add bootmisc boot
chroot alpine /sbin/rc-update add syslog boot
chroot alpine /sbin/rc-update add sshd boot

chroot alpine /sbin/rc-update add mount-ro shutdown
chroot alpine /sbin/rc-update add killprocs shutdown
chroot alpine /sbin/rc-update add savecache shutdown

mkdir -p alpine/root/.ssh
chmod 700 alpine/root/.ssh
cat /home/ben/.ssh/id_ed25519.pub > alpine/root/.ssh/authorized_keys
