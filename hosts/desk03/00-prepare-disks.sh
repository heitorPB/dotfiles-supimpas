#!/usr/bin/env sh
set -o errexit

# This assumes the disk was already partitioned:
# /dev/sda1: 512M           -> /boot
# /dev/sda2: all space left -> zpool for /, /nix, /home, etc
# /dev/sda3: 16G            -> swap

# Create EFI
mkfs.vfat -F32 /dev/sda1

# Swap
mkswap -L swap /dev/sda3
swapon /dev/sda3

# Create zpool
zpool create -f zroot /dev/sda2
zpool set autotrim=on zroot
zfs set compression=lz4 zroot
zfs set mountpoint=none zroot

# Create datasets
zfs create -o mountpoint=legacy zroot/root
zfs create -o mountpoint=legacy zroot/nix
zfs create -o mountpoint=legacy zroot/home
zfs create -o mountpoint=none -o canmount=on zroot/containers

# Mount partitions
mount -t zfs zroot/root /mnt
mkdir -p /mnt/nix /mnt/home /mnt/boot
mount /dev/sda1 /mnt/boot
mount -t zfs zroot/nix /mnt/nix
mount -t zfs zroot/home /mnt/home
