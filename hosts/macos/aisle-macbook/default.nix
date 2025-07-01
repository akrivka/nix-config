{ config, pkgs, ... }:
{
  imports = [ ../default.nix ];

  # Install AISLE specific packages via homebrew
  homebrew = {
    casks = [
      "cursor"
      "orbstack"
      "notion"
      "slack"
    ];
    brews = [
      "git"
      "node"
      "pnpm"
      "python@3.13"
      "rustup"
      "uv"
      "dbmate"
    ];
  };
} 