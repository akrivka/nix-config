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
    ./services/anki-sync-server.nix
    ./services/home-assistant.nix
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
}
