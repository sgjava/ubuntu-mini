## Ubuntu Mini

Ubuntu Mini is lean and mean Ubuntu for ARM based Android Mini PCs. I started
off like a lot of others by using [PicUntu](http://ubuntu.g8.net), but since it
is based on a non-LTS version of Ubuntu I set off to build my own. You can use
the pre-built kernels, build your own or get a kernel elsewhere. This will give
you a lot more flexibility for creating customized distributions.

You will need to identify your hardware since even the same brand names may have
different chipsets. To be safe ask the vendor before buying if possible. I've
personally only tested the MK808 and MK-802IV with 8188eu. In theory, this should
work on any ARM device that can boot a Linux kernel and mount the root file system.

**You assume all the risks that come with flashing an Android device. It's very
painless and hard to screw up, but if you do brick your Mini PC you are on your
own!**

*[Compatibility matrix for selected RK3066 based devices](#compatibility-matrix-for-selected-rk3066-based-devices)

### Compatibility matrix for selected RK3066 based devices
|Device Name 	 |Manufacturer 	|Released 	|NAND flash 	|Wifi Chipset 	|Bluetooth Chipset 	|Special notes                                           |
| -------------- | ------------ | --------- | ------------- | ------------- | ----------------- | ------------------------------------------------------ |
|UG802 	         |Ugoos 	    |May, 2012 	|4 GB 	        |Realtek 8188eus|none 	            |Officially supported                                    |
|MK808 	         |OEM 	        |Sep, 2012 	|4-8 GB 	    |Broadcom 4329 	|none 	            |Officially supported                                    |
|MK802 III 	     |RikoMagic 	|Oct, 2012 	|4-8 GB 	    |Realtek 8188eus|none 	            |Officially supported                                    |
|Neo G4 	     |Minix 	    |Nov, 2012 	|8 GB 	        |Realtek 8188eus|none 	            |Not officially supported, but wifi chipset is supported |
|MK808-B 	     |OEM 	        |Dec, 2012 	|8 GB 	        |Broadcom 4330 	|Broadcom 4330 	    |                                                        |
|MK808-B “clone” |OEM 	        |Dec, 2012 	|8 GB 	        |Mediatek MT5931|Mediatek MT6622 	|                                                        |
|MK808-B “Sunvel”|OEM 	        |Jan, 2013 	|8 GB 	        |Mediatek MT5931|Mediatek MT6622 	|                                                        |
|MK802 IIIB 	 |RikoMagic 	|Jan, 2013 	|4-8 GB 	    |Mediatek MT5931|Mediatek MT6622 	|                                                        |
|UG007 	         |Ugoos 	    |Oct, 2012 	|8 GB 	        |Mediatek MT5931|Mediatek MT6622 	|                                                        |
|MX1/MX2 	     |Imito 	    |Oct, 2012 	|8 GB 	        |Mediatek MT5931|Mediatek MT6622 	|                                                        |
|Neo X5 	     |Minix 	    |Nov, 2012 	|16 GB 	        |Broadcom 4330 	|Broadcom 4330 	    |                                                        |
|MK809 II 	     |Kimdescent 	|Dec, 2012 	|8 GB 	        |Mediatek MT5931|Mediatek MT6622 	|                                                        |
|B12 	         |Kimdescent 	|Jan, 2013 	|8 GB 	        |Mediatek MT5931|Mediatek MT6622 	|Onboard cam   

**This is based on Alok Sihna's 3.0.8 kernel**

### Compatibility matrix for selected RK3188 based devices
|Device Name 	 |Manufacturer 	|Released 	|NAND flash 	|Wifi Chipset 						|Bluetooth Chipset 	|Special notes                                           |
| -------------- | ------------ | --------- | ------------- | --------------------------------- | ----------------- | ------------------------------------------------------ |
|MK802IV         |RikoMagic	    |Apr, 2013 	|8 GB 	        |Realtek 8188 or Broadcom AP6210	|Mediatek MT6622	|Officially supported                                    |
|CX919 	         |OEM 	        |Feb, 2013 	|8 GB 		    |Broadcom AP6210					|Unknown			|Officially supported                                    |
|MK908	 	     |Tronsmart 	|May, 2013 	|8 GB			|Broadcom AP6210					|Unknown 	        |Officially supported                                    |
|QX1	 	     |iMito 	    |May, 2013 	|8 GB 	        |Realtek 8189						|RDA5876A           |Officially supported									 |
|T428	 	     |Tronsmart	    |May, 2013 	|8 GB 	        |Broadcom AP6330					|Unknown			|Officially supported									 |

**This is based on Marvin the Paranoid Android Kernel Builder**

### Supported Network Devices

Note: This list is based upon the kernel and modules available
[here](http://www.rikomagic.co.uk/forum/viewtopic.php?f=12&t=4055#p11058). You
will need to look up the adapter you intend to use and see which chipset it is
using. Then look at the list below to see if the chipset is included.

#### Wired ethernet dongles

* Asix
* DM9601
* MCS7830
* SMSC75xx
* SMSC95xx
* ZD1201

#### WiFi Adapters

* Atheros 9000 series adapters
* Broadcom 40181 adapters
* RALink
    * 2500 series
    * RT73
    * 2800 series
* Realtek
    * 8188eu
    * 8192 series (B/G/N up to 300 MB/sec)
* Zydas 1211

**This is based on Alok Sihna's 3.0.8 kernel**

### Requirements
* Ubuntu 12.04 desktop (I used a VirtualBox VM)
    * Add 8 GB hard disk under Storage using Oracle VM VirtualBox Manager
* A Mini PC with a Rockchip RK3066 dual core ARM A9 processor. The following are officially supported:
    * Ugoos UG802
    * MK808 (w/o bluetooth)
    * Rikomagic MK802 III (w/o bluetooth)
* A monitor or TV with an available HDMI input (I used a Motorola Lapdock).
* An OTG USB cable appropriate for your device. For the Windows PC side we need a full size USB A connector. The Mini PC side of this cable varies, depending on the device. A MK808 uses a Mini USB male connector. The UG802 and the MK802 III use a Micro USB male connector.
* A MicroSD of at least 4GB in size to hold the linuxroot filesystem.
* An internet connection.

### Create Ubuntu root filesystem
1. Install packages
    * `sudo su -`
    * `apt-get -y install qemu-user-static binfmt-support debootstrap`
2. Format 8 GB disk added to VM guest
    * `sfdisk -s` (note 8 GB device is /dev/sdb)
    <pre><code>/dev/sda: 104857600
    /dev/sdb:   8388608
    total: 113246208 blocks</code></pre>
    * `fdisk /dev/sdb`
    <pre><code>n
    p
    Enter
    Enter
    Emter
    w</code></pre>
    * `mkfs.ext4 -L linuxroot /dev/sdb1`
3. Mount partition
    * `mkdir /mnt/tmp`
    * `mount /dev/sdb1 /mnt/tmp`
    * `rm -rf /mnt/tmp/lost+found`
4. Install Ubuntu
    * 12.04
        * `qemu-debootstrap --verbose --variant=minbase --arch=armhf --include=nano precise /mnt/tmp http://ports.ubuntu.com/ubuntu-ports > install.log 2>&1`
    * 14.04
        * `qemu-debootstrap --verbose --variant=minbase --arch=armhf --include=nano trusty /mnt/tmp http://ports.ubuntu.com/ubuntu-ports > install.log 2>&1`
    * Check install.log for **I: Base system installed successfully.**
5. Make backup of minbase
    * `tar -pzcf minbase.tar.gz -C /mnt/tmp .`
6. chroot into new rootfs
    * `mount -t proc proc /mnt/tmp/proc`
    * `mount -t sysfs sysfs /mnt/tmp/sys`
    * `mount -o bind /dev /mnt/tmp/dev`
    * `mount -t devpts devpts /mnt/tmp/dev/pts`
    * `chroot /mnt/tmp`
7. Add apt-sources
    * `nano /etc/apt/sources.list`
        * 12.04
        <pre><code>deb http://ports.ubuntu.com/ubuntu-ports/ precise main restricted universe multiverse
        deb-src http://ports.ubuntu.com/ubuntu-ports/ precise main restricted universe multiverse
        deb http://ports.ubuntu.com/ubuntu-ports/ precise-updates main restricted universe multiverse
        deb-src http://ports.ubuntu.com/ubuntu-ports/ precise-updates main restricted universe multiverse
        deb http://ports.ubuntu.com/ubuntu-ports/ precise-security main restricted universe multiverse
        deb-src http://ports.ubuntu.com/ubuntu-ports/ precise-security main restricted universe multiverse</code></pre>
        * 14.04
        <pre><code>deb http://ports.ubuntu.com/ubuntu-ports/ trusty main restricted universe multiverse
        deb-src http://ports.ubuntu.com/ubuntu-ports/ trusty main restricted universe multiverse
        deb http://ports.ubuntu.com/ubuntu-ports/ trusty-updates main restricted universe multiverse
        deb-src http://ports.ubuntu.com/ubuntu-ports/ trusty-updates main restricted universe multiverse
        deb http://ports.ubuntu.com/ubuntu-ports/ trusty-security main restricted universe multiverse
        deb-src http://ports.ubuntu.com/ubuntu-ports/ trusty-security main restricted universe multiverse</code></pre>
    * `apt-get update`
8. Configure language
    * `apt-get -y install language-pack-en-base`
        * Pick your native language pack instead of en if desired
9. Configure timezone        
    * `dpkg-reconfigure tzdata`
        * Select the geographic area in which you live
        * Select the city or region corresponding to your time zone
10. Add useful packages
    * 12.04
        * `apt-get -y install sudo dhcp3-client udev netbase ifupdown iproute openssh-server iputils-ping wget net-tools wireless-tools wpasupplicant ntpdate ntp less tzdata console-tools console-common module-init-tools`
            * Select keymap from full list
    * 14.04
        * `apt-get -y install sudo isc-dhcp-client udev netbase ifupdown iproute openssh-server iputils-ping wget net-tools wireless-tools wpasupplicant ntpdate ntp less tzdata console-common module-init-tools`
            * Country of origin for the keyboard
            * Keyboard layout
            * Select keymap from full list
    * `apt-get -y upgrade`
11. Configure networking
    * `echo "bcm40181" >> /etc/modules`
        * Change module based on chipset
    * `echo "ubuntu" > /etc/hostname`
    * `nano /etc/network/interfaces` (note device may show up as wlan0)
        * For DHCP
        <pre><code>auto eth0
        iface eth0 inet dhcp</code></pre>
        * For static
        <pre><code>auto eth0
        iface eth0 inet static
        address 192.168.1.69
        netmask 255.255.255.0
        network 192.168.1.0
        broadcast 192.168.1.255
        gateway 192.168.1.1
        dns-nameservers 192.168.1.1
        wpa-ssid ssid
        wpa-psk password</code></pre>
    * `nano /etc/hosts`
        * Add your host
    * `nano /etc/resolv.conf`
        * Change to your DNS server(s)
12. Add user
    * `adduser test`
    * `gpasswd -a test sudo`
13. Create linuxroot archive
    * `exit`
    * `umount /mnt/tmp/{proc,sys,dev/pts,dev,}`
    * `rm -rf /mnt/tmp`
    * Mount linuxroot drive (should show up as /media/linuxroot)
    * `tar -pzcf linuxroot.tar.gz -C /media/linuxroot .`
    * `exit`

### Flash kernel
* Prepare SD
    * `sudo mkfs.ext4 -F -L linuxroot /dev/sdg` (assumes SD device is /dev/sdg, always check first)
    * `sudo tar -pzxf linuxroot.tar.gz -C /media/linuxroot`
* Pick kernel (or build/download one)
    * [RK3066](https://github.com/sgjava/ubuntu-mini/tree/master/rk3066)
    * Extract kernel archive
        * `sudo tar -zxf kernel.tar.gz`
    * Extract modules and firmware (assumes SD mounted as /media/linuxroot)
        * `sudo rm -Rf /media/linuxroot/lib/firmware`
        * `sudo rm -Rf /media/linuxroot/lib/modules`
        * `sudo tar -pzxf mod-fw.tar.gz -C /`
        * `sudo chown root:root -R /media/linuxroot/lib/firmware`
        * `sudo chown root:root -R /media/linuxroot/lib/modules`
        * `sync`
        * Eject SD card from PC
* Flash (assumes you have Finless or other ROM already installed)
    * Extract kernels
        * `tar -zxvf kernel.tar.gz`
    * Install RkFlashKit
        * `git clone https://github.com/linuxerwang/rkflashkit`
        * `cd rkflashkit`
        * `./waf debian`
        * `sudo apt-get install python-gtk2`
        * `sudo dpkg -i rkflashkit_0.1.1_all.deb`
    * Put mini PC into flash mode (typically use a paper clip press flash mode button and hold while plugging OTG port in to PC USB port)
    * `sudo rkflashkit`
        * NAND Partitions - recovery
        * Erase partition
        * Choose recovery.img file
        * Flash image
* Boot
    * Place SD in mini PC
    * Boot into bootloader (assumes Finless or other ROM capable of bootloader and recovery boots)
        * You can also use terminal in Android and `reboot recovery`
    * Log into Ubuntu
    * `sudo depmod -a`
    * `sudo reboot`
* Boot into Linux by default
    * For the MK808 and Finless ROM just boot into recovery and from that point forward only Linux will boot
    * For MK802-IV or to dual boot the MK808 create a init.d script for Android (ROM must support init.d scripts)
        * Boot into Android
        * Mount /system read/write
            * Click on Terminal
            * `su`
            * `mount -o rw,remount /system`
        * Find SD card
            * `ls /dev/block`
            * You should see something like `/dev/block/mmcblk0`
        * Create init.d file (replace `/dev/block/mmcblk0` with actual block device)
            * `cd /etc/init.d`
            * <pre><code>cat <<END > 99boot_linux
            #!/system/xbin/sh
            if [ -b /dev/block/mmcblk0 ]; then
                reboot recovery
            fi
            END</code></pre>
            * `reboot`
            * If SD card is in then Linux boots or else Android boots

### After you can boot successfully
* Force time sync (for some reason ntp doesn't set time on boot)
    * `sudo nano /etc/rc.local`
    * <pre><code>( /etc/init.d/ntp stop
      until ping -nq -c3 8.8.8.8; do
      echo "Waiting for network..."
      done
      ntpdate -s time.nist.gov
      /etc/init.d/ntp start )&</code></pre>
* Install desktop for you GUI lovers
    * `sudo apt-get install xubuntu-desktop`

### Build kernel for Linux
I had issues with the MK808 and internal wireless network building my own
kernels. From various forum posting it looks like others have had success,
so all I can say is good luck.

#### Requirements
* Ubuntu 12.04 desktop (I used a VirtualBox VM)

#### Setting up the build environment
* Ubuntu x86_64
    * `sudo apt-get -y install git-core flex bison build-essential gcc-arm-linux-gnueabihf libncurses5-dev zlib1g-dev lib32z1 lib32ncurses5 sharutils lzop`
* Ubuntu 32 bit
    * `sudo apt-get -y install git-core flex bison build-essential gcc-arm-linux-gnueabihf libncurses5-dev zlib1g-dev sharutils lzop`

#### Build 3.0.8-alok kernel for RK3066
* Create build dir
    * `mkdir -p $HOME/src/rk3066/mod_fw`
    * `cd $HOME/src/rk3066`
* ARM compiler toolchain
    * `git clone https://github.com/DooMLoRD/android_prebuilt_toolchains.git toolchains`
* mkbootimg tool (create recovery image) 
    * `git clone https://github.com/olegk0/tools.git`
* initramfs dir is where the kernel's .config file looks for initramfs.cpio (see CONFIG_INITRAMFS_SOURCE)
    * `git clone https://github.com/Galland/rk30_linux_initramfs.git initramfs`
    * `cd initramfs`
    * `gzip -dc debian-3.0.8+fkubi.cpio.gz > initramfs.cpio`
    * `cd ..`
* picuntu-3.0.8-alok kernel source
    * `git clone https://github.com/aloksinha2001/picuntu-3.0.8-alok.git`
    * `cd picuntu-3.0.8-alok`
    * `nano ../initramfs/config`
        * Find `CONFIG_BOX_FB` and comment out `CONFIG_BOX_FB_720P=y` uncomment `# CONFIG_BOX_FB_480P is not set` and change to `CONFIG_BOX_FB_480P=y` for instance
        * Make any other desired changes
        * Save changes
        * Use `make menuconfig` if you want to go the more hard core route 
    * `cp ../initramfs/config .config`
    * `export ARCH=arm`
    * `export CROSS_COMPILE=$HOME/src/rk3066/toolchains/arm-eabi-linaro-4.6.2/bin/arm-eabi-`
    * `make -j$(getconf _NPROCESSORS_ONLN)`
        * Answer prompts (just press Enter for default value)
        * Don't worry about warnings
* Generate the recovery.img to flash the recovery partition of the mini PC
    * `cd ..`
    * `tools/mkbootimg --kernel picuntu-3.0.8-alok/arch/arm/boot/Image --ramdisk initramfs/fakeramdisk.gz --base 60400000 --pagesize 16384 --ramdiskaddr 62000000 -o recovery.img`
* Create modules
    * `cd picuntu-3.0.8-alok`
    * `make modules_install INSTALL_MOD_PATH=$HOME/src/rk3066/mod_fw`
* Get the firmware files
    * `cd ..`
    * `wget http://cdn02.arctablet.com/mirrors/picuntu/picuntu-linuxroot-0.9-RC2.2.tgz`
    * `tar -zxvf picuntu-linuxroot-0.9-RC2.2.tgz -C mod_fw ./lib/firmware`

#### Build 3.0.36-galland kernel for RK3066 (wireless networking is unstable on MK808)
* Create build dir
    * `mkdir -p $HOME/src/rk3066/mod_fw`
    * `cd $HOME/src/rk3066`
* mkbootimg tool (create recovery image) 
    * `git clone https://github.com/olegk0/tools.git`
* initramfs dir is where the kernel's .config file looks for initramfs.cpio (see CONFIG_INITRAMFS_SOURCE)
    * `git clone https://github.com/Galland/rk30_linux_initramfs.git initramfs`
    * `cd initramfs`
    * `gzip -dc debian-3.0.8+fkubi.cpio.gz > initramfs.cpio`
    * `cd ..`
* rk3x_kernel_3.0.36 kernel source
    * `git clone --depth 1 https://github.com/Galland/rk3x_kernel_3.0.36.git`
    * `cd rk3x_kernel_3.0.36`
    * `nano config.galland`
        * Find `CONFIG_BOX_FB` and comment out `CONFIG_BOX_FB_720P=y` uncomment `# CONFIG_BOX_FB_480P is not set` and change to `CONFIG_BOX_FB_480P=y` for instance
        * Make any other desired changes
        * Save changes
        * Use `make menuconfig` if you want to go the more hard core route 
    * Create compile script
        * `nano build_rk3066`
        <pre><code>#!/bin/bash
        export ARCH=arm
        export CROSS_COMPILE=arm-linux-gnueabihf-
        export LOCALVERSION=
        export INSTALL_MOD_PATH=$HOME/src/rk3066/mod\_fw
        MAKE="make -j$(getconf \_NPROCESSORS\_ONLN)"
        $MAKE clean
        cp config.galland .config
        $MAKE
        rm -rf $INSTALL_MOD_PATH
        $MAKE modules_install</code></pre>
    * `chmod +x build_rk3066`
    * `./build_rk3066`
        * Answer prompts (just press Enter for default value)
        * Don't worry about warnings
* Generate the recovery.img to flash the recovery partition of the mini PC
    * `cd ..`
    * `tools/mkbootimg --kernel rk3x_kernel_3.0.36/arch/arm/boot/Image --ramdisk initramfs/fakeramdisk.gz --base 60400000 --pagesize 16384 --ramdiskaddr 62000000 -o recovery.img`

### Build kernel for Android

#### Build 3.0.8-omegamoon kernel for RK3066 (MK808 or MK808B only)
* Tested with Finless ROM 1.7c
* Create build dir
    * `mkdir -p $HOME/src/rk3066/mod_fw`
    * `cd $HOME/src/rk3066`
* rockchip-rk30xx-mk808 kernel source
    * `git clone https://github.com/omegamoon/rockchip-rk30xx-mk808.git`
    * `cd rockchip-rk30xx-mk808`
    * `./build_mk808_omegamoon_hdmi_720p` (or other build script)
* Flash kernel (This only works on Ubuntu 32 bit)
    * Put mini PC into flash mode (typically use a paper clip press flash mode button and hold while plugging OTG port in to PC USB port)
    * `./flash_mk808_omegamoon`

### References
* [Installing Linux on a RK3066 based device](http://linux.autostatic.com/installing-linux-on-a-rk3066-based-device)
* [Ubuntu Without CD](https://help.ubuntu.com/community/Installation/FromLinux#Without_CD)
* [Your own official Linux distro in a SD card (for ARM)](http://hwswbits.blogspot.com/2013/11/your-own-official-linux-distro-in-sd.html)

### FreeBSD License
Copyright (c) Steven P. Goldsmith

All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

