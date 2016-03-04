branch=v3.3

arch=x86_64
mirror=http://nl.alpinelinux.org/
main_mirror=${mirror}alpine/${branch}/main/
community_mirror=${mirror}alpine/${branch}/community/

chroot_dir=$PWD/alpine
fs=$PWD/filesystem
size=256M
