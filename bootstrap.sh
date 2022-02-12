#!/bin/bash

set -e -u -o pipefail

NIXBLOCKDEVICE=vda

# https://nixos.org/manual/nixos/stable/#sec-installation
parted /dev/${NIXBLOCKDEVICE} -- mklabel gpt
parted /dev/${NIXBLOCKDEVICE} -- mkpart primary 512MiB -8GiB
parted /dev/${NIXBLOCKDEVICE} -- mkpart primary linux-swap -8GiB 100%
parted /dev/${NIXBLOCKDEVICE} -- mkpart ESP fat32 1MiB 512MiB
parted /dev/${NIXBLOCKDEVICE} -- set 3 esp on
mkfs.ext4 -L nixos /dev/${NIXBLOCKDEVICE}1
mkswap -L swap /dev/${NIXBLOCKDEVICE}2
mkfs.fat -F 32 -n boot /dev/${NIXBLOCKDEVICE}3
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1 nixos-install --flake ".#dev" --no-root-passwd -v
reboot

# \o/
