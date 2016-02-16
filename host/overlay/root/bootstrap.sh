#!/bin/sh

apk --update add openssh docker

/sbin/rc-update add devfs sysinit
/sbin/rc-update add dmesg sysinit
/sbin/rc-update add mdev sysinit

/sbin/rc-update add hwclock boot
/sbin/rc-update add modules boot
/sbin/rc-update add sysctl boot
/sbin/rc-update add hostname boot
/sbin/rc-update add bootmisc boot
/sbin/rc-update add syslog boot
/sbin/rc-update add urandom boot
/sbin/rc-update add networking boot

/sbin/rc-update add sshd default
/sbin/rc-update add local default
/sbin/rc-update add docker default
/sbin/rc-update add xo-agent default

/sbin/rc-update add mount-ro shutdown
/sbin/rc-update add killprocs shutdown
/sbin/rc-update add savecache shutdown
