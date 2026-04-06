#!/usr/bin/env sh
set -o errexit

# This assumes the disk was already partitioned:
# /dev/nvme0n1/nvme0n1p1: 1G             -> /boot
# /dev/nvme0n1/nvme0n1p2: 16G            -> swap
# /dev/nvme0n1/nvme0n1p3: all space left -> zpool for /, /nix, /home, etc
# NOTE: /boot MUST have the EFI System type!

# Create EFI
mkfs.vfat -F32 -n BOOT /dev/nvme0n1p1
echo "EFI parition created"

# Swap
mkswap -L swap /dev/nvme0n1p2
swapon /dev/nvme0n1p2
echo "Swap created and activated"

# Create zpool
zpool create -O compression=on \
             -O mountpoint=none \
             -O xattr=sa -O acltype=posixacl -O atime=off \
             zroot /dev/nvme0n1p3
zpool set autotrim=on zroot
echo "zroot zpool created"

zfs create -o refreservation=10G -o mountpoint=none zroot/reserved
echo "Reservation created"

# Create datasets
zfs create -o mountpoint=none   zroot/data
zfs create -o mountpoint=none   zroot/ROOT
zfs create -o mountpoint=legacy zroot/ROOT/empty
zfs create -o mountpoint=legacy zroot/ROOT/nix
zfs create -o mountpoint=legacy zroot/data/persistent

# Snapshot the root partitoin
zfs snapshot zroot/ROOT/empty@start
echo "Datasets and snapshot created"

# Mount partitions
mount -t zfs zroot/ROOT/empty /mnt
mkdir -p -v /mnt/boot /mnt/nix /mnt/home /mnt/boot /mnt/var/persistent
echo "/mnt directories created"

mount /dev/disk/by-label/BOOT /mnt/boot
mount -t zfs zroot/ROOT/nix /mnt/nix
mount -t zfs zroot/data/persistent /mnt/var/persistent

echo "All stuff mounted"
