## Ubuntu Mini

Ubuntu Mini is lean and mean Ubuntu for ARM based Mini PCs. I started off like a lot
of others by using [PicUntu](http://ubuntu.g8.net), but I wanted granular control of
what packages were installed. You can use the pre-built kernels, build your own or
get a kernel elsewhere. This will give you a lot more flexibility for creating customized
distributions.

You will need to identify your hardware since even the same brand names may have
different chipsets. To be safe ask the vendor before buying if possible (a lot of
newer RK3188 devices really have RK3188T CPUs which have problems with various
kernels available). I've personally only tested the MK808, MK-802IV with
8188eu/AP6210 and ODROID C1/C1+. In theory, this should work on any ARM device that
can boot a Linux kernel and mount the root file system.

**You assume all the risks that come with flashing an Android device. It's very
painless and hard to screw up, but if you do brick your Mini PC you are on your
own!**

* [Requirements](#requirements)
* [Compatibility matrix for selected RK3066 based devices](#compatibility-matrix-for-selected-rk3066-based-devices)
* [Compatibility matrix for selected RK3188 based devices](#compatibility-matrix-for-selected-rk3188-based-devices)
* [Supported Network Devices](#supported-network-devices)
    * [Wired ethernet dongles](#wired-ethernet-dongles)
    * [WiFi Adapters](#wifi-adapters)
* [Create Ubuntu root filesystem MK808, MK802IV, etc.](#create-ubuntu-root-filesystem-mk808-mk802iv-etc)
* [Flash kernel](#flash-kernel)
* [Create Ubuntu root filesystem ODROID-C1/C1+](#create-ubuntu-root-filesystem-odroid-c1c1)
* [After you can boot successfully](#after-you-can-boot-successfully)
* [Build kernel for Linux](#build-kernel-for-linux)
    * [Requirements](#requirements-1)
    * [Setting up the build environment](#setting-up-the-build-environment)
    * [Build 3.0.8-alok kernel for RK3066](#build-308-alok-kernel-for-rk3066)
    * [Build 3.0.36-galland kernel for RK3066](#build-3036-galland-kernel-for-rk3066)
* [Build RK3188 kernels with Marvin](#build-rk3188-kernels-with-marvin)
* [Build kernel for Android](#build-kernel-for-android)
    * [Build 3.0.8-omegamoon kernel for RK3066 (MK808 or MK808B only)](#build-308-omegamoon-kernel-for-rk3066-mk808-or-mk808b-only)
* [References](#references)
* [FreeBSD License](#freebsd-license)

### Requirements
* Ubuntu 14.04 desktop (X86_64 required for ODROID C1/C1+ scripts)
    * Add 8 GB hard disk under Storage using Oracle VM VirtualBox Manager in place of an 8 GB SD card
* A Mini PC with a Rockchip RK3066 dual core ARM A9 processor. The following are officially supported:
    * Ugoos UG802
    * MK808 (w/o bluetooth)
    * Rikomagic MK802 III (w/o bluetooth)
* A Mini PC with a Rockchip RK3188 quad core ARM A9 processor. The following are officially supported:
    * Rikomagic MK802-IV
    * OEM CX919
    * Tronsmart MK908
    * iMito QX1
    * Tronsmart T428    
* ODROID C1/C1+ with a quad core ARM Cortex-A5 processor.
* A monitor or TV with an available HDMI input (I used a Motorola Lapdock).
* An OTG USB cable appropriate for your device.
* A MicroSD of at least 4GB in size to hold the linuxroot filesystem.
* An Internet connection.

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
|MK802IV         |RikoMagic	    |May, 2013 	|8 GB 	        |Realtek 8188eus or Broadcom AP6210	|Mediatek MT6622	|Officially supported                                    |
|CX919 	         |OEM 	        |Feb, 2013 	|8 GB 		    |Broadcom AP6330					|Broadcom 4330		|Officially supported                                    |
|MK908	 	     |Tronsmart 	|May, 2013 	|8 GB			|Broadcom AP6210					|Broadcom 4330      |Officially supported                                    |
|QX1	 	     |iMito 	    |May, 2013 	|8 GB 	        |Realtek 8189ES						|RDA5876A           |Officially supported									 |
|T428	 	     |Tronsmart	    |May, 2013 	|8 GB 	        |Broadcom AP6330					|Broadcom 4330 		|Officially supported									 |

**This is based on Marvin the Paranoid Android Kernel Builder**

### Supported Network Devices

Note: You will need to look up the adapter you intend to use and see which
chipset it is using. Then look at the list below to see if the chipset is
included.

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

### Create Ubuntu root filesystem MK808, MK802IV, etc.
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
    * `mkfs.ext4 -O ^metadata_csum -L linuxroot /dev/sdb1`
3. Mount partition
    * `mkdir /mnt/tmp`
    * `mount /dev/sdb1 /mnt/tmp`
    * `rm -rf /mnt/tmp/lost+found`
4. Install Ubuntu
    * 14.04
        * `qemu-debootstrap --verbose --variant=minbase --arch=armhf --include=nano trusty /mnt/tmp http://ports.ubuntu.com/ubuntu-ports > install.log 2>&1`
    * `tail install.log`
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
    * 14.04
        * `apt-get -y install sudo isc-dhcp-client udev netbase ifupdown iproute openssh-server iputils-ping wget net-tools wireless-tools wpasupplicant ntpdate ntp less tzdata console-common module-init-tools`
            * Country of origin for the keyboard
            * Keyboard layout
            * Select keymap from full list
    * `apt-get -y upgrade`
11. Configure networking
    * MK808
        * `echo "bcm40181" >> /etc/modules`
    * MK802IV with AP6210 wifi
        * `echo "rkwifi" >> /etc/modules`
    * Change module based on chipset for other mini PCs
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
    * `umount /mnt/tmp/{proc,sys,dev/pts,dev,}` (This may fail, just reboot)
    * `rm -rf /mnt/tmp`
    * `mkdir /media/linuxroot`
    * `mount /dev/sdb1 /media/linuxroot`
    * `tar -pzcf linuxroot.tar.gz -C /media/linuxroot .`
    * `umount /media/linuxroot`
    * `rm -rf /media/linuxroot`
    * `exit`

### Flash kernel
* Prepare SD
    * `sudo mkfs.ext4 -F -O ^metadata_csum -L linuxroot /dev/sdg` (assumes SD device is /dev/sdg, always check first)
    * `sudo tar -pzxf linuxroot.tar.gz -C /media/linuxroot`
* Pick kernel (or build/download one)
    * [RK3066](https://github.com/sgjava/ubuntu-mini/tree/master/rk3066)
    * [RK3188](https://github.com/sgjava/ubuntu-mini/tree/master/rk3188)
    * Extract kernel archive
        * `sudo tar -zxf kernel.tar.gz`
    * Extract modules and firmware (assumes SD mounted as /media/linuxroot)
        * `sudo rm -Rf /media/linuxroot/lib/firmware`
        * `sudo rm -Rf /media/linuxroot/lib/modules`
        * `sudo tar -pzxf mod-fw.tar.gz -C /`
        * `sudo chown root:root -R /media/linuxroot/lib/firmware`
        * `sudo chown root:root -R /media/linuxroot/lib/modules`
        * If archive contains firmware in /system
            * `sudo chown root:root -R /media/linuxroot/system`
        * `sync`
        * Eject SD card from PC
* Flash (assumes you have Finless or other ROM already installed)
    * Extract kernels
        * `tar -zxvf kernel.tar.gz`
    * Install RkFlashKit
        * `git clone https://github.com/linuxerwang/rkflashkit.git`
        * `cd rkflashkit`
        * `./waf debian`
        * `sudo apt-get install python-gtk2`
        * `sudo dpkg -i binaries/rkflashkit_0.1.1_all.deb`
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
            * You should see something like `mmcblk0`
        * Create init.d file (replace `/dev/block/mmcblk0` with actual block device)
            * `cd /etc/init.d`
            * `touch 99boot_linux`
            * `echo "#!/system/bin/sh" >> 99boot_linux`
            * `echo "if [ -b /dev/block/mmcblk0 ]; then" >> 99boot_linux`
            * `echo "reboot recovery" >> 99boot_linux`
            * `echo "fi" >> 99boot_linux`
            * `cat 99boot_linux`
            * `chmod 777 99boot_linux`
            * `reboot`
            * If SD card is in then Linux boots or else Android boots

### Create Ubuntu root filesystem ODROID-C1/C1+

I automated much of [Ubuntu Minimal Image](http://odroid.com/dokuwiki/doku.php?id=en:c1_ubuntu_minimal)
by using three scripts. My scripts also configure language, timezone and wireless support (disabled by default).
Tested on 01/19/2016.

1. Download scripts on Ubuntu Desktop 14.04 x86_64 (VM is fine)
    * `wget https://raw.githubusercontent.com/sgjava/ubuntu-mini/master/odroid-c1/image.sh`
    * `wget https://raw.githubusercontent.com/sgjava/ubuntu-mini/master/odroid-c1/minimal.sh`
    * `wget https://raw.githubusercontent.com/sgjava/ubuntu-mini/master/odroid-c1/finish.sh`
    * `chmod a+x *.sh`
2. Create image file
    * ``export ubuntu=`pwd` ``
    * `sudo ./image.sh`
3. Install minimal Ubuntu (this script requires user interaction)
    * Once image.sh has completed you should see two Files windows open (boot and target)
    * Copy minimal.sh to chroot /root from a new terminal window
        * Pick different language (default is English)
            * Find `apt-get -y install language-pack-en-base` in minimal.sh and change to desired language pack
        * `sudo cp minimal.sh /home/<username>/ubuntu/target/root/.`
    * chroot
        * `cd ubuntu`
        * `sudo chroot target`
        * `cd /root`
        * `chmod a+x minimal.sh`
        * `./minimal.sh`
            * Geographic area: Select from list
            * Time zone: Select from list
            * Country of origin for the keyboard: Select from list
            * Keyboard layout: Select from list
            * Configuring console-data: &lt;OK&gt;
            * Policy for handling keymaps: Select keymap from full list: &lt;OK&gt;
            * Keymap: Select keymay then &lt;OK&gt;
            * root user: Enter new UNIX password: 
            * root user: Retype new UNIX password:
            * test user: Enter new UNIX password: 
            * test user: Retype new UNIX password: 
            * Full Name []: Test User
            * Room Number []: Press Enter 
            * Work Phone []: Press Enter
            * Home Phone []: Press Enter
            * Other []: Press Enter
            * Is the information correct? [Y/n] Press Enter  
        * `exit`
3. Finish up
    * Unmount image file
        * `cd ..`
        * `sudo ./finish.sh`
        * If there's a `device is busy` error try the following:
            * `sudo reboot`
    * Flash image (change sdX to SD card device)
        * Make sure all partitions have been deleted on SD card (use gparted)
        * `sudo fdisk -l` Find your SD card
        * `sudo dd if=image.img of=/dev/sdX bs=1M`
        * Eject SD
    * boot.ini changes
        * Place SD in PC
        * Edit boot.ini from boot mount
            * I changed the screen resolution to work with my Lapdock
            * For headless server setenv vpu "0" and setenv hdmioutput "0" to save about 140MB RAM. Do this after you can boot successfully and no longer need the display to debug.
    * `nano /etc/network/interfaces.d/wlan0`        
        * Configure wlan0 if needed
        <pre><code>auto wlan0
        iface wlan0 inet static
        address 192.168.1.69
        netmask 255.255.255.0
        gateway 192.168.1.1
        wpa-ssid ssid
        wpa-psk password</code></pre>
    * `nano /etc/hosts`
        * Add your host
    * `nano /etc/resolv.conf`
        * Change to your DNS server(s)
        
### After you can boot successfully
* If you see `Skipping mounting / since Plymouth is not available` on RK3066 or RK3188
  and your file system is read only, do this one time:
    * `sudo mount -o remount,rw /`
    * `sudo reboot`
* RK3066 device CPU temperature in celsius
    * `cat /sys/module/tsadc/parameters/temp* | cut -d " " -f1,2`
* ODROID C1/C1+ device CPU temperature in celsius (I had to devide by 1000)
    * `cat /sys/devices/virtual/thermal/thermal_zone0/temp`
* ODROID C1/C1+ device CPU frequency
    * `cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq`
* Install cpufreq
    * `sudo apt-get install cpufrequtils`
    * `cpufreq-info -o` current settings
    * `cpufreq-info -s` list of speeds you can set
    * `sudo cpufreq-info -w` current speed
    * `sudo cpufreq-set -r --max 1.2GHz` maximum frequency
    * `sudo cpufreq-set -r --min 1.2GHz` minimum frequency
* ODROID C1/C1+ set CPU frequency on boot
    * Disable ondemand governor `sudo update-rc.d ondemand disable`
    * `sudo nano /etc/default/cpufrequtils` settings on start up (this is for ODROID C1 for example)
        * Add `ENABLE="true"`
        * Add `GOVERNOR="conservative"`
        * Add `MAX_SPEED=1632000`
        * Add `MIN_SPEED=96000`
* If fsck hangs boot process make it automatic
    * `sudo nano /etc/default/rcS`
        * Uncomment FSCKFIX and set to yes
* Boot fast
    * `sudo nano /etc/init/failsafe.conf`
        * Comment out all `sleep` commands

### Build kernel for Linux
I had issues with the MK808 and internal wireless network building my own
kernels. From various forum postings it looks like others have had success,
so all I can say is good luck.

#### Requirements
* Ubuntu 14.04 desktop (I used a VirtualBox VM)

#### Setting up the build environment
* Ubuntu x86_64
    * `sudo apt-get -y install git-core flex bison build-essential gcc-arm-linux-gnueabihf gcc-arm-linux-gnueabi libncurses5-dev zlib1g-dev lib32z1 lib32ncurses5 sharutils lzop`
* Ubuntu 32 bit
    * `sudo apt-get -y install git-core flex bison build-essential gcc-arm-linux-gnueabihf gcc-arm-linux-gnueabi libncurses5-dev zlib1g-dev sharutils lzop`

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

#### Build 3.0.36-galland kernel for RK3066
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

#### Build RK3188 kernels with Marvin
* Get Marvin
    * `mkdir android`
    * `cd android`
    * `git clone https://github.com/phjanderson/marvin.git`
* Get RK3188 kernel source tree (pick one)
    * Generic (this has limited driver support)
        * `git clone https://github.com/phjanderson/Kernel-3188.git`
    * Minix Neo X7
        * `git clone https://github.com/phjanderson/Kernel-3188-X7.git`
    * PicUntu
        * `git clone https://github.com/phjanderson/Linux3188.git` (this is what I'll select)
        * For 480P do the following:
            * Get latest kernel [source](https://github.com/aloksinha2001/Linux3188) from Alok's site instead of from Marvin project
            * Change the following in Linux3188/drivers/video/rockchip/hdmi/rk_hdmi.h:
            * `HDMI_VIDEO_DEFAULT_MODE` to `HDMI_720x480p_60HZ_4_3` instead of `HDMI_1920x1080p_60HZ` 
            * Add the following to the end of Linux3188/drivers/video/display/screen/lcd_480p.c (it is missing):
            ```c
            size_t get_fb_size(void)
            {
            	size_t size = 0;
            	#if defined(CONFIG_THREE_FB_BUFFER)
            		size = ((H_VD)*(V_VD)<<2)* 3; //three buffer
            	#else
            		size = ((H_VD)*(V_VD)<<2)<<1; //two buffer
            	#endif
            	return ALIGN(size,SZ_1M);
            }
            ```
        * Fix dwc_otg: support non DWORD-aligned buffer for DMA:
            * Extract [otg-fix.tar.gz](https://github.com/sgjava/ubuntu-mini/raw/master/rk3188/otg-fix.tar.gz)
            * Copy files to Linux3188/drivers/usb/dwc_otg
    * Linuxium
        * `git clone https://github.com/phjanderson/3188-SRC-AP6210.git`
* Get initramfs
    * `git clone https://github.com/Galland/rk30_linux_initramfs.git initramfs`
* mkbootimg tool (create recovery image) 
    * `git clone https://github.com/olegk0/tools.git`
* To build kernels, you'll need to have some software installed for cross compiling (only do this once)
    * `cd marvin`
    * `./marvin install_builddep`
* Select platform
    * `./marvin platform` (to see platforms)
    * `./marvin platform picuntu3188` (I'm going to build with PicUntu kernel)
* Configure kernel
    * `./marvin config` (to see options)
    * `./marvin config mk802iv_rtl8188eu cpu1608h 720p`
* Build kernel and modules
    * `./marvin build_modules`
* Generate the recovery.img to flash the recovery partition of the mini PC
    * `cd ..`
    * `tools/mkbootimg --kernel marvin/platform/picuntu3188/output/kernel_marvin_mk802iv_rtl8188eu/kernel_marvin_mk802iv_rtl8188eu_cpu1608h_720p.img --ramdisk initramfs/fakeramdisk.gz --base 60400000 --pagesize 16384 --ramdiskaddr 62000000 -o recovery.img`

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
* [ODROID C1/C1+ Ubuntu Minimal Image](http://odroid.com/dokuwiki/doku.php?id=en:c1_ubuntu_minimal)

### FreeBSD License
Copyright (c) Steven P. Goldsmith

All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

