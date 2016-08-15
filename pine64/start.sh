#!/bin/sh
#
# Created on Aug 15, 2016
#
# @author: sgoldsmith
#
# First stage of debootstrap for PINE64 that will create minimal Ubuntu 16.04
# (Xenial) root file system. Once the script completes you are in chroot and
# /root/minimal.sh is executed.
#
# Steven P. Goldsmith
# sgjava@gmail.com
# 
# Prerequisites:
#
# o Install latest Ubuntu 16.04 for PINE64 from https://www.stdin.xyz/downloads/people/longsleep/pine64-images/ubuntu
#    o Login to PINE64 and do the following:
#    o sudo apt-get update
#    o sudo apt-get upgrade
# o sudo ./start.sh
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
logfile="$curdir/start.log"
rm -f $logfile

# Get architecture
arch=$(uname -m)

# Ubuntu version
ubuntuver=$DISTRIB_RELEASE

# Simple logger
log(){
	timestamp=$(date +"%m-%d-%Y %k:%M:%S")
	echo "\n$timestamp $1"
	echo "\n$timestamp $1" >> $logfile 2>&1
}

# Install dependenices
log "Installing dependenices..."
apt-get -y install debootstrap >> $logfile 2>&1

# Remove build dir and create
log "Removing builddir $builddir"
rm -rf "$builddir"
mkdir -p "$builddir"

log "Debootstrap first stage to $builddir"
debootstrap --foreign --arch arm64 xenial "$builddir" >> $logfile 2>&1

# Copy next stage minimal.sh
cp "minimal.sh" "$builddir/root/."

# Go to chroot
log "chroot $builddir"
chroot "$builddir" "./root/minimal.sh"

# Get end time
endtime=$(date "$dateformat")
endtimesec=$(date +%s)

# Show elapse time
elapsedtimesec=$(expr $endtimesec - $starttimesec)
ds=$((elapsedtimesec % 60))
dm=$(((elapsedtimesec / 60) % 60))
dh=$((elapsedtimesec / 3600))
displaytime=$(printf "%02d:%02d:%02d" $dh $dm $ds)
log "Elapsed time: $displaytime"
exit 0
