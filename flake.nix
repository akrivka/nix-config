{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source, using the nixos-24.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
  };

  outputs = { self, nixpkgs, vscode-server, ... }@inputs: {
    # Please replace my-nixos with your hostname
    nixosConfigurations = {
      nix-test = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          # Import the previous configuration.nix we used,
          # so the old configuration file still takes effect
          ./machines/vm-test/configuration.nix
          vscode-server.nixosModules.default
          ({ config, pkgs, ... }: {
            services.vscode-server.enable = true;
          })
        ];
      };
    };
  };
}