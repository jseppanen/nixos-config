
# Misc NixOS experiments

Setting up a NixOS dev VM on a Mac M1 laptop.

## Dependencies

**Emulator:** download [UTM.dmg](https://github.com/utmapp/UTM/releases/download/v3.0.4-2/UTM.dmg) from [github.com/utmapp/UTM](https://github.com/utmapp/UTM/releases/).

**Image:** download [nixos-minimal-...-aarch64-linux.iso](https://hydra.nixos.org/build/166864442/download/1/nixos-minimal-21.11.335858.592b893530e-aarch64-linux.iso) from [hydra.nixos.org](https://hydra.nixos.org/job/nixos/release-21.11/nixos.iso_minimal.aarch64-linux).

## Installation

Boot the VM from the ISO image and start the installation from the console. Note that the unstable channel is needed because release-21.11 has too old Nix version (2.3).

```bash
sudo su
nix-channel --add https://nixos.org/channels/nixos-unstable
nix-channel --update
nix-shell -p nix https://github.com/jseppanen/nixos-config/archive/main.tar.gz
```

The installation takes a couple of minutes and after that the VM reboots automatically.

## Development

The installation can also be run locally over SSH, you need to boot from the ISO image and get the VM's IP address with `ifconfig`. The root password also should be changed to something (root).

```make
NIXADDR=192.168.XX.YY make vm/bootstrap
```
