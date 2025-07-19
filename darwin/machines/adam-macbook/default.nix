{ config, pkgs, ... }:
{
  imports = [ ../../default.nix ];

  # Add personal MacBook specific configuration here
    homebrew = {
    casks = [
      "discord"
      "cursor"
      "orbstack"
    ];
    brews = [
      "git"
      "node"
      "pnpm"
      "python@3.13"
      "uv"
      "gh"
    ];
    masApps = {
      WireGuard = 1451685025;
    };
  };
} 