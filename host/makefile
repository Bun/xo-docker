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

clean:
	rm -rf sbin .PKGINFO .SIGN.* *.apk
	rm -rf alpine filesystem

# wget -N http://nl.alpinelinux.org/alpine//latest-stable/releases/x86_64/alpine-3.3.1-x86_64.iso
# mount -t iso9660 -o loop alpine-3.3.1-x86_64.iso iso

deploy:
	cp iso/boot/vmlinuz-grsec docker-host/vmlinuz-grsec
	cp iso/boot/initramfs-grsec docker-host/initramfs-grsec
	(cd docker-host && ../../bin/xo-image-xml http://geni-images.uvalight.net/ben/docker-host/ \
		filesystem.tgz vmlinuz-grsec initramfs-grsec) > docker-host/docker-host.xml
	rsync -av --delete docker-host/ geni-images.uvalight.net:share/docker-host/
