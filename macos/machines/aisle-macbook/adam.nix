{ config, pkgs, ... }:
{
  imports = [ ../../adam.nix ];

  # Expose Karabiner config from repository into ~/.config/karabiner.
  xdg.configFile."karabiner".source = ../../configs/karabiner-iso;
}
