#!/bin/sh
#
# Created on Feb 6, 2015
#
# @author: sgoldsmith
#
# Clean up after minimal.sh has run and you exit chroot.
#
# This work is based on http://odroid.com/dokuwiki/doku.php?id=en:c1_ubuntu_minimal
#
# Steven P. Goldsmith
# sgjava@gmail.com
# 
# Prerequisites:
#
# o minimal.sh completed and exit chroot prompt
# o sudo ./finish.sh
#

# Get current directory
curdir=$(cd `dirname $0` && pwd)

# Build dir
builddir="$curdir/ubuntu"

# Target dir (without path)
target="target"

# stdout and stderr for commands logged
logfile="$curdir/finish.log"
rm -f $logfile

# Simple logger
log(){
	timestamp=$(date +"%m-%d-%Y %k:%M:%S")
	echo "\n$timestamp $1"
	echo "\n$timestamp $1" >> $logfile 2>&1
}

# Clean ups and preparation to test the image
log "Unmounting image"
cd "$builddir"
umount "$target"/media/boot
umount "$target"
sync
losetup -d /dev/loop0
exit 0
