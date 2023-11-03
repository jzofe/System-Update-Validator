# :penguin: System Update Validator - SUV | Ender Project

! This script is an ENDER project

Check if the new update really works! All Linux distros!

Has there been an update to your Linux operating system? Check whether the incoming update is faulty or not with this script!

### How does work?

- It creates a virtual disk and downloads the update in that virtual disk in the packet manager of the OS you selected. If the update is faulty, it deletes the virtual disk and tells you that the update is faulty. If it's not wrong, it will download it.

## Install

WARNING : Default os Arch-Linux

```
sudo suv.sh #Arch

sudo suv.sh --ubuntu #Ubuntu

sudo suv.sh --debian #Debian

sudo suv.sh --centos #Centos
```
