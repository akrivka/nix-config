{ config, pkgs, ... }:
{
  imports = [ ../default.nix ];

  # Add personal MacBook specific configuration here
    homebrew = {
    casks = [
      "discord"
      "cursor"
    ];
    brews = [
      "git"
      "node"
      "pnpm"
      "python@3.13"
      "uv"
    ];
    masApps = {
      WireGuard = 1451685025;
    };
  };
} 