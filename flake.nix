{
  description = "Misc NixOS dev box";

  inputs = {
    # Pin our primary nixpkgs repository. This is the main nixpkgs repository
    # we'll use for our configurations. Be very careful changing this because
    # it'll impact your entire system.
    nixpkgs.url = "github:nixos/nixpkgs/release-22.11";

    # We use the unstable nixpkgs repo for some packages.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";

      # We want home-manager to use the same set of nixpkgs as our system.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "aarch64-linux";
      user   = "jarno";
    in {
    nixosConfigurations.dev = nixpkgs.lib.nixosSystem rec {
      inherit system;

      modules = [
        # Apply our overlays. Overlays are keyed by system type so we have
        # to go through and apply our system type. We do this first so
        # the overlays are available globally.

        ./hardware-configuration.nix
        ./configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${user} = import ./users/${user}/home.nix;
        }
      ];
    };
  };
}
