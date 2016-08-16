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

# Get start time
dateformat="+%a %b %-eth %Y %I:%M:%S %p %Z"
starttime=$(date "$dateformat")
starttimesec=$(date +%s)

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
cp -a "/boot/." "$builddir/boot/"

# Copy /lib/modules 
log "Copy /lib/modules"
mkdir -p "$builddir/lib/modules"
cp -a "/lib/modules/." "$builddir/lib/modules/"

# Copy /etc/fstab 
log "Copy /etc/fstab"
cp "/etc/fstab" "$builddir/etc/."

# Build archive of root file system 
log "Build archive of root file system"
tar -pzcf pine64-xenial-arm64.tar.gz -C "$builddir" .

# Get end time
endtime=$(date "$dateformat")
endtimesec=$(date +%s)

# Show elapse time
elapsedtimesec=$(expr $endtimesec - $starttimesec)
ds=$((elapsedtimesec % 60))
dm=$(((elapsedtimesec / 60) % 60))
dh=$((elapsedtimesec / 3600))
displaytime=$(printf "%02d:%02d:%02d" $dh $dm $ds)

log "Elapsed time: $displaytime\n"
exit 0
