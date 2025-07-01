{ config, pkgs, ... }:

{
  nix.enable = false;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    with pkgs; [ 
      neovim
      git
      python3
    ];

  nixpkgs.hostPlatform = "aarch64-darwin";

  # Enable alternative shell support in nix-darwin.
  # programs.fish.enable = true;

  # Enable flakes
  nix.settings.experimental-features = "nix-command flakes";

  # Enable Homebrew (all macOS hosts can extend this in their own configs)
  homebrew = {
    enable = true;
    casks = [
      "betterdisplay"
      "firefox"
      "ghostty"
      "marta"
      "spotify"
      "raycast"
      "visual-studio-code"
      "bitwarden"
      "karabiner-elements"
    ];
    onActivation.autoUpdate = true;
    onActivation.cleanup = "zap";
    global.brewfile = true;
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # Define the existing macOS user so that Home-Manager can infer the correct
  # home directory path (required for the `home.homeDirectory` option).
  users.users.adam.home = "/Users/adam";
}