{
  modulesPath,
  inputs,
  config,
  lib,
  ...
}:
{
  imports = [
    "${modulesPath}/profiles/qemu-guest.nix"
    "${modulesPath}/virtualisation/lxc-container.nix"
  ];

  # Default filesystem
  fileSystems."/" = lib.mkDefault {
    device = "/dev/disk/by-label/nixos";
    autoResize = true;
    fsType = "ext4";
  };

  boot.growPartition = lib.mkDefault true;
}
