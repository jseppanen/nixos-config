# Connectivity info for Linux VM
NIXADDR ?= 192.168.64.6
NIXPORT ?= 22
NIXUSER ?= jarno

# Settings
NIXBLOCKDEVICE ?= vda

# Get the path to this Makefile and directory
MAKEFILE_DIR := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

# SSH options that are used. These aren't meant to be overridden but are
# reused a lot so we just store them up here.
SSH_OPTIONS=-o PubkeyAuthentication=no -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no

switch:
	sudo NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1 nixos-rebuild switch --flake ".#dev"

test:
	sudo NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1 nixos-rebuild test --flake ".#dev"

# bootstrap a brand new VM. The VM should have NixOS ISO on the CD drive
# and just set the password of the root user to "root". This will install
# NixOS.
vm/bootstrap:
	$(MAKE) vm/copy
	$(MAKE) vm/install
	# $(MAKE) vm/secrets

vm/install:
	ssh $(SSH_OPTIONS) -p$(NIXPORT) $(NIXUSER)@$(NIXADDR) " \
		sudo nix-channel --add https://nixos.org/channels/nixos-unstable; \
		sudo nix-channel --update; \
		sudo nix-shell -p nix /nix-config/default.nix \
	"

# copy our secrets into the VM
vm/secrets:
	# GPG keyring
	# rsync -av -e 'ssh $(SSH_OPTIONS)' \
	# 	--exclude='.#*' \
	# 	--exclude='S.*' \
	# 	--exclude='*.conf' \
	# 	$(HOME)/.gnupg/ $(NIXUSER)@$(NIXADDR):~/.gnupg
	# SSH keys
	rsync -av -e 'ssh $(SSH_OPTIONS)' \
		--exclude='environment' \
		$(HOME)/.ssh/ $(NIXUSER)@$(NIXADDR):~/.ssh

# copy the Nix configurations into the VM.
vm/copy:
	rsync -av -e 'ssh $(SSH_OPTIONS) -p$(NIXPORT)' \
		--exclude='vendor/' \
		--exclude='.git/' \
		--exclude='.git-crypt/' \
		--exclude='iso/' \
		--rsync-path="sudo rsync" \
		$(MAKEFILE_DIR)/ $(NIXUSER)@$(NIXADDR):/nix-config

vm/copyback:
	rsync -av -e 'ssh $(SSH_OPTIONS) -p$(NIXPORT)' \
		--exclude='vendor/' \
		--exclude='.git/' \
		--exclude='.git-crypt/' \
		--exclude='iso/' \
		--rsync-path="sudo rsync" \
		$(NIXUSER)@$(NIXADDR):/nix-config/ $(MAKEFILE_DIR)
