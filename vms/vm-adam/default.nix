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
    ./services/paperless-ngx.nix
    ./services/syncthing.nix
    ./services/anki-sync-server.nix
    ./services/home-assistant.nix
    #./services/mealie.nix
    #./services/gitea.nix
  ];

  # DO NOT CHANGE THIS!!! 
  # https://search.nixos.org/options?channel=unstable&show=system.stateVersion&from=0&size=50&sort=relevance&type=packages&query=system.stateVersion
  system.stateVersion = lib.mkDefault "24.11";

  #Provide a default hostname
  networking = {
    hostName = "vm-adam";
  };

  # Create a empty folders /data/Adam/Drive, /data/Adam/Photos and /data/Adam/Services
  # using activation scripts
  system.activationScripts = {
    create-folders = {
      text = ''
        mkdir -p /data/Adam/Drive
        chown -R syncthing /data/Adam/Drive
        mkdir -p /data/Adam/Services/immich
        [ ! -L /data/Adam/Photos ] && ln -s /data/Adam/Services/immich/library/admin /data/Adam/Photos'';
    };
  };

  services.borgbackup.jobs.adam = {
    paths = [ "/data/Adam" ];
    repo = "ssh://ryloth@scarif/mnt/zfs-2024-09-08/backup2/Adam";
    compression = "zstd,3";
    encryption.mode = "none";
    prune.keep = {
      within = "1d"; # Keep all backups from the last 24 hours
      daily = 7; # Keep the last backup for each day for 7 days
      weekly = 4; # Keep the last backup for each week for 4 weeks
      monthly = 6; # Keep the last backup for each month for 6 months
      yearly = 1; # Keep the last backup for each year for 1 year
    };
  };

  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Automatically apply system upgrades once per day
  system.autoUpgrade = {
    enable = true;
    flake = "/root/nix-config#vm-adam"; # build this host's flake every upgrade
    flags = [
      "--update-input" "nixpkgs"   # pull latest nixpkgs revision
      "--no-write-lock-file"        # don't commit lock file changes
      "-L"                          # print build logs
    ];
    dates = "02:00";               # run daily at 02:00
    randomizedDelaySec = "45min";  # spread load when multiple machines upgrade
  };
}
