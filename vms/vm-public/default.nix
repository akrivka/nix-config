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
    ./services/cloudflared.nix
  ];

  # DO NOT CHANGE THIS!!! 
  # https://search.nixos.org/options?channel=unstable&show=system.stateVersion&from=0&size=50&sort=relevance&type=packages&query=system.stateVersion
  system.stateVersion = lib.mkDefault "24.11";

  # Provide a default hostname
  networking = {
    hostName = "vm-public";
  };

  # Create directory for web content
  system.activationScripts = {
    create-web-dirs = {
      text = ''
        mkdir -p /var/www/cmg.akrivka.com
        mkdir -p /var/www/cmg.akrivka.com/fotky
        chown -R caddy:caddy /var/www/cmg.akrivka.com
      '';
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
    flake = "/root/nix-config#vm-public"; # build this host's flake every upgrade
    flags = [
      "--update-input" "nixpkgs"   # pull latest nixpkgs revision
      "--no-write-lock-file"        # don't commit lock file changes
      "-L"                          # print build logs
    ];
    dates = "02:00";               # run daily at 02:00
    randomizedDelaySec = "45min";  # spread load when multiple machines upgrade
  };
}