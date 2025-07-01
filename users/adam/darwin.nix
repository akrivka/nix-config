{ config, pkgs, ... }:
{
  home.username = "adam";
  home.homeDirectory = "/Users/adam";

  # Keep this in sync with your current Home-Manager version.
  home.stateVersion = "23.11";

  # Expose Karabiner config from repository into ~/.config/karabiner.
  xdg.configFile."karabiner/karabiner.json".source = ../../hosts/macos/configs/karabiner/karabiner.json;

  # Optionally, include additional user packages.
  home.packages = [ ];
} 