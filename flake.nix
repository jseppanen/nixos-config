{
  description = "Misc NixOS dev box";

  inputs = {
    # Pin our primary nixpkgs repository. This is the main nixpkgs repository
    # we'll use for our configurations. Be very careful changing this because
    # it'll impact your entire system.
    nixpkgs.url = "github:nixos/nixpkgs/release-21.11";

    # We use the unstable nixpkgs repo for some packages.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-21.11";

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
        { nixpkgs.overlays = [
          (final: prev: {
            # To get Kitty 0.24.x. Delete this once it hits release.
            kitty = inputs.nixpkgs-unstable.legacyPackages.${prev.system}.kitty;
          })
          ];
        }

        ./hardware-configuration.nix
        ./configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${user} = import ./users/${user}/home.nix;
        }
      ];

      extraArgs = {
        currentSystem = system;
      };
    };
  };
}
