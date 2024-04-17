#!/usr/bin/env sh
set -o errexit

# This assumes the disk was already partitioned:
# /dev/nvme0n1/nvme0n1p1: 512M           -> /boot
# /dev/nvme0n1/nvme0n1p2: 16G            -> swap
# /dev/nvme0n1/nvme0n1p3: all space left -> zpool for /, /nix, /home, etc

# Create EFI
mkfs.vfat -F32 -n BOOT /dev/nvme0n1p1
echo -e "EFI parition created\n"

# Swap
mkswap -L swap /dev/nvme0n1p2
swapon /dev/nvme0n1p2
echo -e "Swap created and activated\n"

# Create zpool
zpool create -f zroot /dev/nvme0n1p3
zpool set autotrim=on zroot
zfs set compression=on zroot
zfs set mountpoint=none zroot
echo -e "zroot zpool created\n"

# Create datasets
zfs create -o mountpoint=none   zroot/data
zfs create -o mountpoint=none   zroot/data/homes
zfs create -o mountpoint=none   zroot/ROOT
zfs create -o mountpoint=legacy zroot/ROOT/empty
zfs create -o mountpoint=legacy zroot/ROOT/nix
zfs create -o mountpoint=legacy zroot/data/persistent
zfs create -o mountpoint=legacy zroot/data/homes/j

# Snaptshot the root partitoin
zfs snapshot zroot/ROOT/empty@start
echo -e "Datasets and snapshot created\n"

# Mount partitions
mount -t zfs zroot/ROOT/empty /mnt
mkdir -p -v /mnt/boot /mnt/nix /mnt/home /mnt/boot /mnt/var/persistent
echo -e "/mnt directories created\n"

mount /dev/disk/by-label/BOOT /mnt/boot
mount -t zfs zroot/ROOT/nix /mnt/nix
mount -t zfs zroot/data/persistent /mnt/var/persistent

echo -e "All stuff mounted"
