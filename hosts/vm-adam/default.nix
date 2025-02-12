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

    ./hardware-configuration.nix

    ./services/caddy.nix
    ./services/immich.nix
    ./services/syncthing.nix
    #./services/gitea.nix
  ];

  system.stateVersion = lib.mkDefault "24.11";  

  #Provide a default hostname
  networking = {
    hostName = "vm-adam";
  };

}
