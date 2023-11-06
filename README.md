
> **Warning**
> maintenance

## :penguin: System Update Validator - SUV | Ender Project

open-source

! This script is an ENDER project 

Check if the new update really works! All Linux distros!

Has there been an update to your Linux operating system? Check whether the incoming update is faulty or not with this script!

### How does work?

- It creates a virtual disk and downloads the update in that virtual disk in the packet manager of the OS you selected. If the update is faulty, it deletes the virtual disk and tells you that the update is faulty. If it's not wrong, it will download it.

## Install

WARNING : Default os Arch-Linux

```shell
sudo suv.sh #Arch
```
```shell
sudo suv.sh --ubuntu #Ubuntu
```
```shell
sudo suv.sh --debian #Debian
```
```shell
sudo suv.sh --centos #Centos
```

Commands (-h)

```shell

Create a virtual disk and test the update.

Options:
    -s <SIZE> Specify the virtual disk size (for example, 2G, 1024M). Default: 300M.
    --ubuntu Use Ubuntu package manager
    --debian Use Debian package manager
    --centos Use CentOS package manager (yum)
    -h View help
```

Coded By Fyks / scriptkidsensei
