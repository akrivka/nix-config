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
        text = ''mkdir -p /data/Adam/Drive
                 chown -R syncthing /data/Adam/Drive
                 [ ! -L /data/Adam/Photos ] && ln -s /data/Adam/Services/immich/library/admin /data/Adam/Photos
                 mkdir -p /data/Adam/Services/immich'';
    };
  };  

  # BACKUP to scarif using restic
  services.restic.backups = {
    local = {
      repository = "sftp:ryloth@scarif:/mnt/zfs-2024-09-08/backup2/Adam";
      paths = [ "/data/Adam" ];
      timerConfig = {
        OnCalendar = "daily";
      };
      passwordFile = "./restic-password";
      initialize = true;
    };
  };
}
