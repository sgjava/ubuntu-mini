#!/bin/sh
#
# Created on Feb 6, 2015
#
# @author: sgoldsmith
#
# Build 4 GB image file for ODROID-C1 that will contain Ubuntu 14.04 (Trusty). Once
# the script completes you are in chroot and must copy and run minimal.sh next.
#
# This work is based on http://odroid.com/dokuwiki/doku.php?id=en:c1_ubuntu_minimal
#
# WARNING: This script has the ability to install/remove Ubuntu packages and it also
# installs some libraries from source. This could potentially screw up your system,
# so use with caution! I suggest using a VM for testing before using it on your
# physical systems.
#
# Steven P. Goldsmith
# sgjava@gmail.com
# 
# Prerequisites:
#
# o Install Ubuntu 14.04 x86_64, update (I used VirtualBox for testing) Internet
#   connection is required to download libraries, frameworks, etc.
#    o sudo apt-get update
#    o sudo apt-get upgrade
#    o sudo apt-get dist-upgrade
# o sudo ./image.sh
#

# Get start time
dateformat="+%a %b %-eth %Y %I:%M:%S %p %Z"
starttime=$(date "$dateformat")
starttimesec=$(date +%s)

# Get current directory
curdir=$(cd `dirname $0` && pwd)

# Build dir
builddir="$curdir/ubuntu"

# Image file name (without path)
image="image.img"

# Target dir (without path)
target="target"

# stdout and stderr for commands logged
logfile="$curdir/image.log"
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

# Use shared lib?
if [ "$arch" = "x86_64" ]; then
	log "Correct architecture $arch"
else
	log "Incorrect architecture $arch, but requires x86_64"
	exit 1
fi

log "Creating ODROID-C1 image file on Ubuntu $ubuntuver$arch"

# Install dependenices
log "Installing dependenices..."
apt-get -y install debootstrap qemu-user-static >> $logfile 2>&1

# Remove build dir and create
log "Removing builddir $builddir"
rm -rf "$builddir"
mkdir -p "$builddir"
cd "$builddir"
export ubuntu=`pwd`

# Create a image with 4096 1Mbyte blocks (4Gbyte image)
log "Creating image file $image"
dd if=/dev/zero of=./$image bs=1M count=4096 >> $logfile 2>&1

# Create fat32 partition for kernel+initramfs+boot script
log "Creating fat32 partition"
echo "n
p
1

+128M
w
"|fdisk $image >> $logfile 2>&1

# Create ext4 partition for the OS
log "Creating ext4 partition"
echo "n
p
2


w
"|fdisk $image >> $logfile 2>&1

# Formatting and setting up partitions
# Setup loopback and format the partitions
# Also change the UUID and disable journaling

losetup /dev/loop0 ./$image >> $logfile 2>&1
partprobe /dev/loop0 >> $logfile 2>&1
log "Formatting fat partition"
mkfs.vfat -n boot /dev/loop0p1 >> $logfile 2>&1
log "Formatting ext4 partition"
mkfs.ext4 -L rootfs /dev/loop0p2 >> $logfile 2>&1
log "Change UUID"
tune2fs /dev/loop0p2 -U e139ce78-9841-40fe-8823-96a304a09859 >> $logfile 2>&1
log "Disable journaling"
tune2fs -O ^has_journal /dev/loop0p2 >> $logfile 2>&1

# Download a pre-built version of U-Boot for C1 and fuse the image
log "Downloading pre-built version of U-Boot for C1 to fuse to $image"
wget https://raw.githubusercontent.com/mdrjr/c1_uboot_binaries/master/bl1.bin.hardkernel >> $logfile 2>&1
wget https://raw.githubusercontent.com/mdrjr/c1_uboot_binaries/master/u-boot.bin >> $logfile 2>&1
wget https://raw.githubusercontent.com/mdrjr/c1_uboot_binaries/master/sd_fusing.sh >> $logfile 2>&1
chmod +x sd_fusing.sh >> $logfile 2>&1
log "Fusing to $image"
./sd_fusing.sh /dev/loop0 >> $logfile 2>&1

# Mount the partitions, copy qemu to enable chroot to arm and start debootstrap
log "Debootstrap $target"
mkdir -p "$target" >> $logfile 2>&1
mount /dev/loop0p2 "$target" >> $logfile 2>&1
mkdir -p "$target"/media/boot >> $logfile 2>&1
mount /dev/loop0p1 "$target"/media/boot >> $logfile 2>&1
mkdir -p "$target"/usr/bin >> $logfile 2>&1
cp /usr/bin/qemu-arm-static "$target"/usr/bin >> $logfile 2>&1
debootstrap --variant=buildd --arch armhf trusty "$target" http://ports.ubuntu.com >> $logfile 2>&1

# Get end time
endtime=$(date "$dateformat")
endtimesec=$(date +%s)

# Show elapse time
elapsedtimesec=$(expr $endtimesec - $starttimesec)
ds=$((elapsedtimesec % 60))
dm=$(((elapsedtimesec / 60) % 60))
dh=$((elapsedtimesec / 3600))
displaytime=$(printf "%02d:%02d:%02d" $dh $dm $ds)
log "Elapse time: $displaytime"
exit 0
