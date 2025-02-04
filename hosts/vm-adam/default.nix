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

    ./../vm-adam/services/caddy.nix
    ./../vm-adam/services/immich.nix
    ./../vm-adam/services/syncthing.nix
    ./../vm-adam/services/gitea.nix
  ];

  #Provide a default hostname
  networking = {
    hostName = "vm-test";
  };

  system.stateVersion = lib.mkDefault "24.11";

  # Enable QEMU Guest for Proxmox
  #services.qemuGuest.enable = lib.mkDefault true;

}
