#!/bin/sh
#
# Created on Aug 15, 2016
#
# @author: sgoldsmith
#
# Second stage of debootstrap for PINE64 that will create minimal Ubuntu 16.04
# (Xenial) root file system. This is an interactive script!
#
# Steven P. Goldsmith
# sgjava@gmail.com
# 
# Prerequisites:
#
# o start.sh completed
#

# Get start time
dateformat="+%a %b %-eth %Y %I:%M:%S %p %Z"
starttime=$(date "$dateformat")
starttimesec=$(date +%s)

# Start off in root dir
cd "/root"

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

# debootstrap second stage
log "Debootstrap second stage"
/debootstrap/debootstrap --second-stage

# Add repos
log "Configuring repositories"
cat << EOF > /etc/apt/sources.list
deb http://ports.ubuntu.com/ubuntu-ports/ xenial main universe restricted
deb-src http://ports.ubuntu.com/ubuntu-ports/ xenial main universe restricted

deb http://ports.ubuntu.com/ubuntu-ports/ xenial-updates main universe restricted
deb-src http://ports.ubuntu.com/ubuntu-ports/ xenial-updates main universe restricted

deb http://ports.ubuntu.com/ubuntu-ports/ xenial-backports main restricted
deb-src http://ports.ubuntu.com/ubuntu-ports/ xenial-backports main restricted

deb http://ports.ubuntu.com/ubuntu-ports/ xenial-security main restricted
deb-src http://ports.ubuntu.com/ubuntu-ports/ xenial-security main restricted
deb http://ports.ubuntu.com/ubuntu-ports/ xenial-security universe
deb-src http://ports.ubuntu.com/ubuntu-ports/ xenial-security universe
deb http://ports.ubuntu.com/ubuntu-ports/ xenial-security multiverse 
deb-src http://ports.ubuntu.com/ubuntu-ports/ xenial-security multiverse

deb http://ports.ubuntu.com/ubuntu-ports/ xenial multiverse
deb-src http://ports.ubuntu.com/ubuntu-ports/ xenial multiverse
deb http://ports.ubuntu.com/ubuntu-ports/ xenial-updates multiverse
deb-src http://ports.ubuntu.com/ubuntu-ports/ xenial-updates multiverse
EOF

apt-get update >> $logfile 2>&1

# Pick your native language pack instead of en if desired
log "Configure language"
apt-get -y install language-pack-en-base 

log "Configure timezone"
dpkg-reconfigure tzdata

log "Installing base packages"
apt-get -y install sudo software-properties-common isc-dhcp-client udev netbase ifupdown iproute openssh-server iputils-ping wget net-tools wireless-tools wpasupplicant ntpdate ntp less tzdata console-common nano

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
echo "pine64" > /etc/hostname

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

log "Elapsed time: $displaytime\n"
exit 0
