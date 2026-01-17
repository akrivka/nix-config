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

  hardware.opengl.enable = true;

  # Intel VA-API and media drivers
  environment.systemPackages = with pkgs; [
    intel-media-driver
    libva-utils
    vpl-gpu-rt
  ];

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

  users.groups.render = {};
  users.users.jellyfin = {
    extraGroups = [ "render" ];
  };

  services.flaresolverr = {
    enable = true;
  };

  services.caddy = {
    enable = true;

    virtualHosts.":80".extraConfig = ''
      respond "Hello from vm-fun"
    '';

    virtualHosts."http://jellyfin.fun".extraConfig = ''
      reverse_proxy :8096
    '';

    virtualHosts."http://transmission.fun".extraConfig = ''
      reverse_proxy :9091
    '';

    virtualHosts."http://bazarr.fun".extraConfig = ''
      reverse_proxy :6767
    '';

    virtualHosts."http://sonarr.fun".extraConfig = ''
      reverse_proxy :8989
    '';

    virtualHosts."http://radarr.fun".extraConfig = ''
      reverse_proxy :7878
    '';

    virtualHosts."http://prowlarr.fun".extraConfig = ''
      reverse_proxy :9696
    '';

    virtualHosts."http://readarr.fun".extraConfig = ''
      reverse_proxy :8787
    '';

    virtualHosts."http://lidarr.fun".extraConfig = ''
      reverse_proxy :8686
    '';

    virtualHosts."http://jellyseerr.fun".extraConfig = ''
      reverse_proxy :5055
    '';

    virtualHosts."http://flaresolverr.fun".extraConfig = ''
      reverse_proxy :8191
    '';
  };

  networking.firewall.allowedTCPPorts = [
    80
  ];

  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Automatically apply system upgrades once per day
  system.autoUpgrade = {
    enable = true;
    flake = "/root/nix-config#vm-fun"; # build this host's flake every upgrade
    flags = [
      "--update-input" "nixpkgs"   # pull latest nixpkgs revision
      "--no-write-lock-file"        # don't commit lock file changes
      "-L"                          # print build logs
    ];
    dates = "02:00";               # run daily at 02:00
    randomizedDelaySec = "45min";  # spread load when multiple machines upgrade
  };
}
