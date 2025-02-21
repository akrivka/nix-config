{ config, pkgs, ... }:

{
  nix.enable = false;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    with pkgs; [ 
      vim
      git
      python3
    ];

  nixpkgs.hostPlatform = "aarch64-darwin";

  # Enable alternative shell support in nix-darwin.
  # programs.fish.enable = true;

  # Enable flakes
  nix.settings.experimental-features = "nix-command flakes";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;
}