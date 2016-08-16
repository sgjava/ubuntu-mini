#!/bin/sh
#
# Created on Aug 15, 2016
#
# @author: sgoldsmith
#
# Copy files required to boot and for kernel support.
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
builddir="$curdir/xenial-arm64"

# stdout and stderr for commands logged
logfile="$curdir/finish.log"
rm -f $logfile

# Simple logger
log(){
	timestamp=$(date +"%m-%d-%Y %k:%M:%S")
	echo "\n$timestamp $1"
	echo "\n$timestamp $1" >> $logfile 2>&1
}

# Copy /boot 
log "Copy /boot"
cp -R "/boot/*" "$builddir/boot/."

# Copy /lib/modules 
log "Copy /lib/modules"
mkdir -p "$builddir/lib/modules"
cp -R "/lib/modules/*" "$builddir/lib/modules/."

# Copy /etc/fstab 
log "Copy /etc/fstab"
cp -R "/etc/fstab" "$builddir/etc/."

exit 0
