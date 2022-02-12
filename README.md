
# Misc NixOS experiments

## Emulator

Download [UTM.dmg](https://github.com/utmapp/UTM/releases/download/v3.0.4-2/UTM.dmg) from https://github.com/utmapp/UTM/releases/

## Image

Download [nixos-minimal-...-aarch64-linux.iso](https://hydra.nixos.org/build/166864442/download/1/nixos-minimal-21.11.335858.592b893530e-aarch64-linux.iso) from https://hydra.nixos.org/job/nixos/release-21.11/nixos.iso_minimal.aarch64-linux

## Installation

Boot the VM, and using the graphical console, change the root password to "root":

```
$ sudo su
$ passwd
# change to root
```

Run `ifconfig` and get the IP address of the first device. It is probably
`192.168.58.XXX`, but it can be anything. In a terminal with this repository
set this to the `NIXADDR` env var:

```
$ export NIXADDR=<VM ip address>
```

Perform the initial bootstrap. This will install NixOS on the VM disk image
but will not setup any other configurations yet. This prepares the VM for
any NixOS customization:

```
$ make vm/bootstrap0
```

After the VM reboots, run the full bootstrap, this will finalize the
NixOS customization using this configuration:

```
$ make vm/bootstrap
```

You should have a graphical functioning dev VM.
