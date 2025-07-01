{
  description = "Adam Krivka's NixOS flake";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixarr = {
      url = "github:rasmus-kirk/nixarr";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, nixarr, nix-darwin, home-manager, ... }@inputs:
    {
      nixosConfigurations = {

        nix-test = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./hosts/vms/vm-test ];
        };

        vm-adam = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./hosts/vms/vm-adam ];
        };

        vm-fun = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ 
            ./hosts/vms/vm-fun 
            nixarr.nixosModules.default
          ];
        };
      };

      darwinConfigurations = {
        adam-macbook = nix-darwin.lib.darwinSystem {
          modules = [
            ./hosts/macos/adam-macbook
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              # Home-Manager configuration for the primary user.
              home-manager.users.adam = import ./users/adam/darwin.nix;
            }
          ];
        };
        aisle-macbook = nix-darwin.lib.darwinSystem {
          modules = [
            ./hosts/macos/aisle-macbook
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              # Re-use the same user configuration on the AISLE MacBook.
              home-manager.users.adam = import ./users/adam/darwin.nix;
            }
          ];
        };
      };
    };
}
