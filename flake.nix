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
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    {
      nixosConfigurations = {

        nix-test = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./hosts/vm-test ];
        };

        vm-adam = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          extraSpecialArgs = {inherit inputs};
          modules = [ ./hosts/vm-adam ];
        };
      };
    };
}
