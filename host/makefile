.PHONY: all clean img

all:
	bash umount.sh
	bash setup.sh
	bash mount.sh
	bash post-setup.sh

img:
	bash umount.sh
	mkdir -p docker-host
	tar czf docker-host/filesystem.tgz filesystem

postimg:
	bash mount.sh
	bash post-setup.sh
	make img


docker-host/initramfs: initrd/init
	../bin/xo-mkinitrd initrd docker-host/initramfs

clean:
	rm -rf sbin .PKGINFO .SIGN.* *.apk
	rm -rf alpine filesystem

deploy: docker-host/initramfs
	rsync -av linux-grsec/boot/vmlinuz-grsec docker-host/vmlinuz-grsec
	(cd docker-host && ../../bin/xo-image-xml http://geni-images.uvalight.net/images/ben/docker-host/ \
		filesystem.tgz vmlinuz-grsec initramfs) > docker-host/docker-host.xml
	rsync -av --delete docker-host/ geni-images.uvalight.net:share/docker-host/
