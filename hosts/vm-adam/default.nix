{
  config,
  pkgs,
  modulesPath,
  lib,
  system,
  ...
}:

{
  imports = [
    ../common
    ../common/users/adam.nix

    ./hardware-configuration.nix

    ./services/caddy.nix
    ./services/immich.nix
    ./services/syncthing.nix
    ./services/gitea.nix
  ];

  #Provide a default hostname
  networking = {
    hostName = "vm-adam";
  };

  system.stateVersion = lib.mkDefault "24.11";
}
