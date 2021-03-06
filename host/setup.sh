#!/bin/sh

set -e

source config.sh

xo_create_fs() {
    echo "Creating filesystem"
    if test -e "${fs}"
    then
        rm "${fs}"
    fi

    truncate -s "${size}" "${fs}"
    mkfs.ext4 -F "${fs}"

    rm -rf "${chroot_dir}"
    mkdir "${chroot_dir}"
}

xo_mount() {
    echo "Mounting base image"
    mount -o loop "${fs}" "${chroot_dir}"
}

xo_install() {
    echo "Installing base image"
    mkdir -p ${chroot_dir}/etc/apk
    cp -r apk-keys/ ${chroot_dir}/etc/apk/keys/

    apk-tools-static/sbin/apk.static --update-cache \
        --repository "${main_mirror}" \
        --root "${chroot_dir}" \
        --initdb \
        add alpine-base
}

xo_install_agent() {
    echo "Installing agent"
    mkdir -p "${chroot_dir}/usr/sbin"
    cp ../xo-agent/xo-agent "${chroot_dir}/usr/sbin/xo-agent"
    cp ../xo-agent/agent-init "${chroot_dir}/etc/init.d/xo-agent"
}

xo_kmod_install() {
    mkdir -p "${chroot_dir}/lib/modules/$1"
    if [ -z "$2" ]
    then
        rsync -av "linux-grsec/lib/modules/$1/" "${chroot_dir}/lib/modules/$1/"
    else
        cp -v "linux-grsec/lib/modules/$1/$2" "${chroot_dir}/lib/modules/$1/$2"
    fi
}

xo_kmods() {
    echo "Installing modules"

    kver=$(ls -1 linux-grsec/lib/modules/ | head -1)

    mkdir -p "${chroot_dir}/lib/modules/$kver"
    cp -v "linux-grsec/lib/modules/$kver/"modules.* "${chroot_dir}/lib/modules/$kver/"

    xo_kmod_install "$kver/kernel/drivers/acpi/" "button.ko"
    xo_kmod_install "$kver/kernel/drivers/acpi/" "processor.ko"
    xo_kmod_install "$kver/kernel/drivers/ata/" "ata_generic.ko"
    xo_kmod_install "$kver/kernel/drivers/ata/" "ata_piix.ko"
    xo_kmod_install "$kver/kernel/drivers/ata/" "libata.ko"
    xo_kmod_install "$kver/kernel/drivers/ata/" "pata_acpi.ko"
    xo_kmod_install "$kver/kernel/drivers/block/" "loop.ko"
    xo_kmod_install "$kver/kernel/drivers/block/" "virtio_blk.ko"
    xo_kmod_install "$kver/kernel/drivers/net/ethernet/realtek/" "8139cp.ko"
    xo_kmod_install "$kver/kernel/drivers/net/ethernet/realtek/" "8139too.ko"
    xo_kmod_install "$kver/kernel/drivers/net/" "mii.ko"
    xo_kmod_install "$kver/kernel/drivers/net/" "veth.ko"
    xo_kmod_install "$kver/kernel/drivers/net/" "virtio_net.ko"
    xo_kmod_install "$kver/kernel/drivers/parport/" "parport.ko"
    xo_kmod_install "$kver/kernel/drivers/parport/" "parport_pc.ko"
    xo_kmod_install "$kver/kernel/drivers/scsi/" "iscsi_tcp.ko"
    xo_kmod_install "$kver/kernel/drivers/scsi/" "libiscsi.ko"
    xo_kmod_install "$kver/kernel/drivers/scsi/" "libiscsi_tcp.ko"
    xo_kmod_install "$kver/kernel/drivers/scsi/" "scsi_mod.ko"
    xo_kmod_install "$kver/kernel/drivers/scsi/" "scsi_transport_iscsi.ko"
    xo_kmod_install "$kver/kernel/fs/autofs4/" "autofs4.ko"
    xo_kmod_install "$kver/kernel/fs/ext4/" "ext4.ko"
    xo_kmod_install "$kver/kernel/fs/jbd2/" "jbd2.ko"
    xo_kmod_install "$kver/kernel/fs/" "mbcache.ko"
    xo_kmod_install "$kver/kernel/fs/overlayfs/" "overlay.ko"
    xo_kmod_install "$kver/kernel/lib/" "crc16.ko"
    xo_kmod_install "$kver/kernel/net/802/" "stp.ko"
    xo_kmod_install "$kver/kernel/net/bridge/" "bridge.ko"
    xo_kmod_install "$kver/kernel/net/bridge/" "br_netfilter.ko"
    xo_kmod_install "$kver/kernel/net/ipv6/" "ipv6.ko"
    xo_kmod_install "$kver/kernel/net/llc/" "llc.ko"
    xo_kmod_install "$kver/kernel/net/packet/" "af_packet.ko"

    xo_kmod_install "$kver/kernel/drivers/virtio/"
    xo_kmod_install "$kver/kernel/drivers/infiniband/"
    xo_kmod_install "$kver/kernel/net/ipv4/netfilter/"
    xo_kmod_install "$kver/kernel/net/netfilter/"
}

xo_chroot_prep() {
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
}

xo_create_fs
xo_mount
xo_install
xo_install_agent
xo_kmods
xo_chroot_prep

echo "Done"
