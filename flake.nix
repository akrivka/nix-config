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
    { self, nixpkgs, nixarr, nix-darwin, ... }@inputs:
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
          modules = [ ./hosts/macos/adam-macbook ];
        };
        aisle-macbook = nix-darwin.lib.darwinSystem {
          modules = [ ./hosts/macos/aisle-macbook ];
        };
      };
    };
}
