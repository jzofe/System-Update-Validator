#!/bin/bash

display_help() {
    echo "Usage: $0 [OPTION]"
    echo "Create a virtual disk and test the update."
    echo
    echo "Options:"
    echo " -s <SIZE> Specify the virtual disk size (for example, 2G, 1024M). Default: 300M."
    echo " --ubuntu Use Ubuntu package manager"
    echo " --debian Use Debian package manager"
    echo " --centos Use CentOS package manager (yum)."
    echo " -h View help."
    exit 1
}

clear

err="9G"
disk_size="300M"
ubuntu_mode=false
debian_mode=false
centos_mode=false
check="Arch-Linux"

while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -s)
            disk_size="$2"
            if [[ $(echo $disk_size | tr -d 'MGmg') -gt $(echo $err | tr -d 'MGmg') ]]; then
                echo ""
                echo -e "\e[31mERR:\e[0m You entered a disk size greater than $err. Please enter a size of $err or smaller."
                exit 1
            fi
            shift 2
            ;;
        -h)
            display_help
            ;;
        --ubuntu)
            ubuntu_mode=true
            check="Ubuntu"
            shift
            ;;
        --debian)
            debian_mode=true
            check="Debian"
            shift
            ;;
        --centos)
            centos_mode=true
            check="CentOS"
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

if [ "$EUID" -ne 0 ]; then
    echo "Permission denied! Type 'sudo chmod +x suv.sh'. "
    exit 1
fi

clear
echo -e "\e[1mSystem Update Validator - SUV | EnderProject\e[0m"
echo ""
echo "Command : $check"
echo "Virtual disk size : $disk_size"
sleep 3
echo "Creating virtual disk"
for i in {1..5}; do
    sleep 1
    echo -n "."
done
echo

sleep 1

disk_size_without_unit=$(echo $disk_size | tr -d 'MGmg')
dd if=/dev/zero of=virtual_disk.img bs=1M count=0 seek=$disk_size_without_unit
loop_device=$(sudo losetup -fP virtual_disk.img --show)
sudo mkfs.ext4 $loop_device
sudo mkdir -p /mnt/suv_virtual
sudo mount $loop_device /mnt/suv_virtual

if $ubuntu_mode; then
    sudo pacstrap /mnt/suv_virtual base
elif $debian_mode; then
    sudo debootstrap stable /mnt/suv_virtual
elif $centos_mode; then
    sudo debootstrap centos /mnt/suv_virtual
else
    sudo pacstrap /mnt/suv_virtual base
fi

echo -e "\e[1mVirtual disk created.\e[0m"
sleep 2
echo -e "\e[32mSUV:\e[0m Trying update"
for i in {1..5}; do
    sleep 1
    echo -n "."
done

echosudo mount -t proc /proc /mnt/suv_virtual/proc
sudo mount --rbind /sys /mnt/suv_virtual/sys
sudo mount --rbind /dev /mnt/suv_virtual/dev

if $ubuntu_mode || $debian_mode || $centos_mode; then
    sudo chroot /mnt/suv_virtual
    sudo chroot /mnt/suv_virtual sudo apt-get update -y
    sudo chroot /mnt/suv_virtual sudo apt-get install aircrack-ng -y
    if $centos_mode; then
        sudo chroot /mnt/suv_virtual yum update -y
        sudo chroot /mnt/suv_virtual yum install aircrack-ng -y
    fi
else
    sudo arch-chroot /mnt/suv_virtual
    sudo arch-chroot /mnt/suv_virtual /bin/bash -c "pacman -Sy --noconfirm"
    sudo arch-chroot /mnt/suv_virtual /bin/bash -c "pacman -S --noconfirm aircrack-ng"
fi

if [ $? -eq 0 ]; then
    echo -e "\e[32mSUV:\e[0m No error detected in this update. Update working!."
    sleep 1
    echo ""
    read -p "Would you like to download the update? (y/n): " download_choice
    if [ "$download_choice" == "Y" ] || [ "$download_choice" == "y" ]; then
        if $ubuntu_mode || $debian_mode || $centos_mode; then
            sudo chroot /mnt/suv_virtual sudo apt-get upgrade -y
            if $centos_mode; then
                sudo chroot /mnt/suv_virtual yum update -y
            fi
        else
            sudo pacman -Syu --noconfirm
        fi
        echo "Downloading update..."
    else
        echo "ERROR!"
    fi
else
    echo ""
    echo ""
    echo -e "\e[31mERR:\e[0m The update is faulty!"
    sleep 1
    echo ""
    echo "Virtual disk deleting"
    for i in {1..5}; do
        sleep 1
        echo -n "."
    done
    echo
fi

sudo umount /mnt/suv_virtual
sudo losetup -d $loop_device
