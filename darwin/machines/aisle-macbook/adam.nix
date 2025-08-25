{ config, pkgs, ... }:
{
  imports = [ ../../adam.nix ];

  # Expose Karabiner config from repository into ~/.config/karabiner.
  xdg.configFile."karabiner/karabiner.json".source = ./configs/karabiner/karabiner-iso.json;
} 