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
  ];

  system.stateVersion = lib.mkDefault "24.11";  

  #Provide a default hostname
  networking = {
    hostName = "vm-fun";
  };

  # nixarr
  nixarr = {
    enable = true;

    jellyfin.enable = true;
    transmission.enable = true;
    bazarr.enable = true;
    sonarr.enable = true;
    radarr.enable = true;
    prowlarr.enable = true;
    readarr.enable = true;
    lidarr.enable = true;
    jellyseerr.enable = true;
  };

  services.caddy = {
    enable = true;

    virtualHosts.":80".extraConfig = ''
      respond "Hello from vm-fun"
    '';

    virtualHosts."http://jellyfin.fun".extraConfig = ''
    reverse_proxy :8096
    '';
  };
}
