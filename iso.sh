#!/bin/sh
set -e
. ./build.sh

mkdir -p isodir
mkdir -p isodir/boot
mkdir -p isodir/boot/grub

cp sysroot/boot/browseros.kernel isodir/boot/browseros.kernel
cat > isodir/boot/grub/grub.cfg << EOF
menuentry "BrowserOS" {
	multiboot /boot/browseros.kernel
}
EOF
grub-mkrescue -o browseros.iso isodir
