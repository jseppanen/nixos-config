
# Misc NixOS experiments

Setting up a NixOS dev VM on a Mac M1 laptop.

## Dependencies

**Emulator:** download [UTM.dmg](https://github.com/utmapp/UTM/releases/download/v4.0.9/UTM.dmg) from [github.com/utmapp/UTM](https://github.com/utmapp/UTM/releases/).

**Image:** download [nixos-minimal-22.11...aarch64-linux.iso](https://channels.nixos.org/nixos-22.11/latest-nixos-minimal-aarch64-linux.iso) from [nixos.org](https://nixos.org/download.html#nixos-iso).

## Installation

Create a new Linux VM in UTM:
* Use NixOS boot ISO image
* Disable hardware OpenGL acceleration
* Enable retina mode

Boot the VM and start the installation from the console.

```bash
sudo su
loadkeys fi  # change keyboard layout if needed
nix-shell https://github.com/jseppanen/nixos-config/archive/main.tar.gz
```

The installation takes a couple of minutes and after that the VM reboots automatically.

By default, the OS is installed to the `/dev/vda` disk, which corresponds to the VirtIO Drive in QEMU, but this can be changed as follows:

```bash
sudo nix-shell --argstr blockDevice sda https://github.com/jseppanen/nixos-config/archive/main.tar.gz
```

## Development

The installation can also be run locally over SSH, you need to boot from the ISO image and get the VM's IP address with `ifconfig`. The root password also should be changed to something (root).

```make
NIXADDR=192.168.XX.YY make vm/bootstrap
```
