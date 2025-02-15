{
  description = "Adam Krivka's NixOS flake";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
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
    { self, nixpkgs, nixarr, ... }@inputs:
    {
      nixosConfigurations = {

        nix-test = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./hosts/vm-test ];
        };

        vm-adam = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./hosts/vm-adam ];
        };

        vm-fun = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ 
            ./hosts/vm-fun 
            nixarr.nixosModules.default
          ];
        };
      };
    };
}
