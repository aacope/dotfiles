# Name: gentoo_install.sh
# Description: Kind of maybe sort of broken but not script to automate Gentoo install and really it's use at your own risk at this point.
# Author: Aaron Copeland
# Date: 08/12/16



# Next line is everything installed during installation process, this is a note for later
#emerge vim sys-kernel/gentoo-sources sys-apps/pciutils syslog-ng cronie mlocate sshd e2fsprogs linux-firmware btrfs-progs grub:2 dhcpcd sudo htop logrotate

# ROOT INSTALLED after install: , this is a note for later
#emerge xf86-video-intel alsa-driver libvirt sys-apps/usermode-utilities app-text/tree 

# USER INSTALLED after install (so far): , this is a note for later
#emerge firefox pulseaudio pavucontrol lm_sensors acpitool xfce4-battery-plugin xfwm4-themes xfce4-sensors-plugin xfce4-mount-plugin firefox-bin virt-manager gnustep-apps/preview qlipper parcellite feh net-irc/irrsi ristretto p7zip dev-vcs/git cifs-utils apvlv evince openoffice-bin app-emulation/docker gedit vlc audacious geany nfs-utils aufs-util btrfs-utils btrfs-progs xrandr arandr pv thunar-shares-plugin gvfsd-fuse sys-fs/fuse bridge-utils app-emulation/spice virtualbox-guest-additions virtualbox-bin grsync leafpad wicd tmux transmission chromium-bin qemu xarchiver meld porthole mesa-progs xarg media-fonts/arphicfonts media-fonts/bitstream-cyberbit media-fonts/droid media-fonts/ipamonafont media-fonts/ja-ipafonts media-fonts/takao-fonts media-fonts/wqy-microhei media-fonts/wqy-zenhei nmap wireshark tcpdump mutt filezilla gimp thunderbird mplayer openconnect libstoken unrar xhost virtualbox-modules rdesktop fortune-mod-homer fortune-mod-hitchhiker fortune-mod-starwars fortune-mod-familyguy cowsay fortune-mod-futurama bsod host bind-tools icedtea www-client/midori app-misc/screen terminator x11-misc/xclip evolution evolution-ews thunar 


# Starting at Installing the Gentoo base system https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base

mirrorselect -i -o >> /mnt/gentoo/etc/portage/make.conf
mkdir /mnt/gentoo/etc/portage/repos.conf
cp /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf
cat /mnt/gentoo/etc/portage/repos.conf/gentoo.conf
cp -L /etc/resolv.conf /mnt/gentoo/etc/
mount -t proc proc /mnt/gentoo/proc
mount --rbind /sys /mnt/gentoo/sys
mount --make-rslave /mnt/gentoo/sys
mount --rbind /dev /mnt/gentoo/dev
mount --make-rslave /mnt/gentoo/dev
chroot /mnt/gentoo /bin/bash
source /etc/profile
export PS1="(chroot) $PS1"
emerge-webrsync
# Kind of sketchy way to select the default desktop profile, use "select profile list" to change (well might be too late if you ran this script haha)
# Really REALLY need to make this better
eselect profile list | grep desktop | grep -v 'gnome\|kde\|plasma' | grep -o '[0-9]\+' | grep -v '64\|13\|0' | xargs -n1 eselect profile set 


# Starting after modifying make.conf, mirrors, etc and updating system first time
# below is same as emerge --ask --update --deep --newuse @world
emerge -auDN @world
# Next step is optional but wayyyyyy better than nano
emerge vim
# Shows current USE variables
emerge --info | grep ^USE
# Using Eastern EST, look here for more options: ls /usr/share/zoneinfo
echo "US/Eastern" > /etc/timezone
emerge --config sys-libs/timezone-data
echo "en_US ISO-8859-1" >> /etc/locale.gen
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
# Kind of sketchy way to automate "eselect locale list" for en_US.utf8...
eselect locale list | grep en_US.utf8 | grep -o '[0-7]\+' | xargs -n1 eselect locale set
env-update && source /etc/profile && export PS1="(chroot) $PS1"

# Now onto Configuring the Linux kernel https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Kernel
emerge --ask sys-kernel/gentoo-sources
ls -l /usr/src/linux
emerge --ask sys-apps/pciutils
# For manual config do this, couldn't automate this, sorry guys!
#cd /usr/src/linux
#make menuconfig
#make && make modules_install && make install
#emerge --ask sys-kernel/genkernel
#genkernel --install initramfs
# Add this for raid or lvm, etc (example)
#genkernel --lvm --mdadm --install initramfs

# Genkernel
emerge --ask sys-kernel/genkernel
echo "Modify the /etc/fstab file with partition layout."
genkernel --install initramfs
genkernel all
ls /boot/kernel* /boot/initramfs*
# Checking for modules 
find /lib/modules/<kernel version>/ -type f -iname '*.o' -or -iname '*.ko' | less
echo "CAUTION: Add the corresponding modules that apply for your machine to /etc/conf.d/modules or it may not boot!"
# Add the corresponding modules you want to "/etc/conf.d/modules" in this format:
#modules="3c59x"
emerge --ask sys-kernel/linux-firmware

# Change hostname in /etc/conf.d/hostname
echo "bestmachinever" > /etc/conf.d/hostname
# Change dns_domain_lo="homenetwork"
echo "dns_domain_lo=\"network\"" >> /etc/conf.d/net
emerge --ask --noreplace net-misc/netifrc
echo config_$NETINT="dhcp" >> /etc/conf.d/net
ln -s /etc/init.d/net.lo /etc/init.d/net.enp2s0
rc-update add net.$NETINT default
echo "put hostname in /etc/hosts"
# Better change your passwd
echo "set root passwd" 
# Super insecure way of setting passwords for root
echo "changeme" | passwd root --stdin
emerge syslog-ng cronie mlocate

rc-update add syslog-ng default
rc-update add cronie default
rc-update add sshd default

emerge sys-fs/e2fsprogs
emerge sys-fs/btrfs-progs
emerge net-misc/dhcpcd
emerge sys-boot/grub:2
#if UEFI do this instead of above
#echo GRUB_PLATFORMS="efi-64" >> /etc/portage/make.conf
#emerge --ask sys-boot/grub:2
# if you forget to change above, you'll need to run below
#emerge --ask --update --newuse --verbose sys-boot/grub:2
#bios runs next item
grub2-install /dev/sda
#UEFI runs next item
#grub2-install --target=x86_64-efi --efi-directory=/boot
grub2-mkconfig -o /boot/grub/grub.cfg
useradd -m -G users,wheel -s /bin/bash aaron
# Here's that super insecure password setting again! Ewwww
echo "changeme" | passwd aaron --stdin
rm /stage3-*.tar.bz2*
emerge sudo
exit
cd
umount -l /mnt/gentoo/dev{/shm,/pts,}
umount /mnt/gentoo{/boot,/sys,/proc,}
reboot




