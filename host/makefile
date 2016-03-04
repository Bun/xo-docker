.PHONY: all clean img prepare

include config.sh

all: apk-tools-static linux-grsec
	bash umount.sh
	bash setup.sh
	bash mount.sh
	bash post-setup.sh

##

prepare:
	wget ${main_mirror}APKINDEX.tar.gz -O apk-cache/APKINDEX.tar.gz
	../bin/apk-fetch-latest "${main_mirror}${arch}/" apk-cache apk-tools-static
	../bin/apk-fetch-latest "${main_mirror}${arch}/" apk-cache linux-grsec

apk-tools-static: apk-cache/apk-tools-static.apk
	rm -rf $@
	mkdir $@
	tar xf $< -C $@ 2>/dev/null

linux-grsec: apk-cache/linux-grsec.apk
	rm -rf $@
	mkdir $@
	tar xf $< -C $@ 2>/dev/null

##

.PHONY: initrd

initrd: linux-grsec | docker-host/initramfs
	cp -a linux-grsec/boot/vmlinuz-grsec docker-host/vmlinuz-grsec


docker-host/initramfs: apk-cache/linux-grsec.apk initrd/init | linux-grsec
	../bin/xo-mkinitrd initrd docker-host/initramfs


##

img:
	bash umount.sh
	mkdir -p docker-host
	tar czf docker-host/filesystem.tgz filesystem

postimg:
	bash mount.sh
	bash post-setup.sh
	make img

clean:
	rm -rf linux-grsec apk-tools-static
	rm -rf alpine filesystem

deploy: docker-host/initramfs
	(cd docker-host && ../../bin/xo-image-xml http://geni-images.uvalight.net/images/ben/docker-host/ \
		filesystem.tgz vmlinuz-grsec initramfs) > docker-host/docker-host.xml
	rsync -av --delete docker-host/ geni-images.uvalight.net:share/docker-host/
