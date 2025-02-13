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

  # Create a empty folders /data/Adam/Drive, /data/Adam/Photos and /data/Adam/Services
  # using activation scripts
  system.activationScripts = {
      create-folders = {
        text = ''mkdir -p /data/Adam/Drive
                 mkdir -p /data/Adam/Photos
                 mkdir -p /data/Adam/Services'';
    };
  };  
}
