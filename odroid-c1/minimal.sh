#!/bin/sh
#
# Created on Feb 6, 2015
#
# @author: sgoldsmith
#
# Build minimal Ubuntu 14.04 (Trusty) for ODROID-C1. This script is interactive
# and must be copied and run as chroot.
#
# This work is based on http://odroid.com/dokuwiki/doku.php?id=en:c1_ubuntu_minimal
#
# Steven P. Goldsmith
# sgjava@gmail.com
# 
# Prerequisites:
#
# o image.sh completed and you are at chroot prompt
# o Copy ./minimal.sh to chroot root dir
# o cd /root
# o ./minimal.sh
#

# Get start time
dateformat="+%a %b %-eth %Y %I:%M:%S %p %Z"
starttime=$(date "$dateformat")
starttimesec=$(date +%s)

# Get current directory
curdir=$(cd `dirname $0` && pwd)

# stdout and stderr for commands logged
logfile="$curdir/minimal.log"
rm -f $logfile

# Simple logger
log(){
	timestamp=$(date +"%m-%d-%Y %k:%M:%S")
	echo "\n$timestamp $1"
	echo "\n$timestamp $1" >> $logfile 2>&1
}

# Will add hardkernel keys and repositories, fix ubuntu respository list and install the basic set of tools for a minimal image
log "Configuring repositories"
cat << EOF > /etc/apt/sources.list
deb http://ports.ubuntu.com/ubuntu-ports/ trusty main universe restricted
deb-src http://ports.ubuntu.com/ubuntu-ports/ trusty main universe restricted

deb http://ports.ubuntu.com/ubuntu-ports/ trusty-updates main universe restricted
deb-src http://ports.ubuntu.com/ubuntu-ports/ trusty-updates main universe restricted

deb http://ports.ubuntu.com/ubuntu-ports/ trusty-backports main restricted
deb-src http://ports.ubuntu.com/ubuntu-ports/ trusty-backports main restricted

deb http://ports.ubuntu.com/ubuntu-ports/ trusty-security main restricted
deb-src http://ports.ubuntu.com/ubuntu-ports/ trusty-security main restricted
deb http://ports.ubuntu.com/ubuntu-ports/ trusty-security universe
deb-src http://ports.ubuntu.com/ubuntu-ports/ trusty-security universe
deb http://ports.ubuntu.com/ubuntu-ports/ trusty-security multiverse  
deb-src http://ports.ubuntu.com/ubuntu-ports/ trusty-security multiverse

deb http://ports.ubuntu.com/ubuntu-ports/ trusty multiverse
deb-src http://ports.ubuntu.com/ubuntu-ports/ trusty multiverse
deb http://ports.ubuntu.com/ubuntu-ports/ trusty-updates multiverse
deb-src http://ports.ubuntu.com/ubuntu-ports/ trusty-updates multiverse
EOF

apt-get update >> $logfile 2>&1

# Pick your native language pack instead of en if desired
log "Configure language"
apt-get -y install language-pack-en-base 

log "Configure timezone"
dpkg-reconfigure tzdata

log "Installing base packages"
apt-get -y install sudo software-properties-common u-boot-tools isc-dhcp-client udev netbase ifupdown iproute openssh-server iputils-ping wget net-tools wireless-tools wpasupplicant ntpdate ntp less tzdata console-common nano

log "Add ORDOID keys and update"
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys AB19BAC9 >> $logfile 2>&1
echo "deb http://deb.odroid.in/c1/ trusty main" > /etc/apt/sources.list.d/odroid.list
echo "deb http://deb.odroid.in/ trusty main" >> /etc/apt/sources.list.d/odroid.list
apt-get update >> $logfile 2>&1
apt-get -y install linux-image-c1 bootini >> $logfile 2>&1
cp /boot/uImage* /media/boot/uImage

# Setup ethernet as DHCP, create the loopback interface, leave wireless commented out
log "Configuring networking"
cat << EOF > /etc/network/interfaces.d/lo
auto lo
iface lo inet loopback
EOF

cat << EOF > /etc/network/interfaces.d/eth0
auto eth0
iface eth0 inet dhcp
EOF

# Set hostname
echo "odroidc1" > /etc/hostname

# Enable the Serial console
log "Enable serial console"
echo "start on stopped rc or RUNLEVEL=[12345]" > /etc/init/ttyS0.conf
echo "stop on runlevel [!12345]" >> /etc/init/ttyS0.conf
echo "respawn" >> /etc/init/ttyS0.conf
echo "exec /sbin/getty -L 115200 ttyS0 vt102" >> /etc/init/ttyS0.conf

# Making /media/boot mounting at boot time
log "Making /media/boot mounting at boot time"
echo "LABEL=boot /media/boot vfat defaults 0 0" >> /etc/fstab

# Setting a root password
log "Change root password"
passwd root

# Adding new user
log "Add test user with sudo access"
adduser test
adduser test sudo

# Get end time
endtime=$(date "$dateformat")
endtimesec=$(date +%s)

# Show elapse time
elapsedtimesec=$(expr $endtimesec - $starttimesec)
ds=$((elapsedtimesec % 60))
dm=$(((elapsedtimesec / 60) % 60))
dh=$((elapsedtimesec / 3600))
displaytime=$(printf "%02d:%02d:%02d" $dh $dm $ds)

log "Elapse time: $displaytime\n"
exit 0
