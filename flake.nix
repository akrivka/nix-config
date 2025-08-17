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
          modules = [ ./vms/vm-test ];
        };

        vm-adam = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./vms/vm-adam ];
        };

        vm-fun = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ 
            ./vms/vm-fun 
            nixarr.nixosModules.default
          ];
        };

        vm-public = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ 
            ./vms/vm-public 
            nixarr.nixosModules.default
          ];
        };
      };

      darwinConfigurations = {
        adam-macbook = nix-darwin.lib.darwinSystem {
          modules = [
            ./darwin/machines/adam-macbook
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.backupFileExtension = "backup";

              home-manager.users.adam = import ./darwin/adam.nix;
            }
          ];
        };
        aisle-macbook = nix-darwin.lib.darwinSystem {
          modules = [
            ./darwin/machines/aisle-macbook
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.backupFileExtension = "backup";

              home-manager.users.adam = import ./darwin/adam.nix;
            }
          ];
        };
      };
    };
}
