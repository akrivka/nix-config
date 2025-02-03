{ config, pkgs, modulesPath, lib, system, ... }:

{
  imports = [
    "${modulesPath}/profiles/qemu-guest.nix"
    "${modulesPath}/virtualisation/lxc-container.nix"

    ./../../services/caddy.nix
  ];

  config = {
    #Provide a default hostname
    networking.hostName = "vm-test";

    # Enable QEMU Guest for Proxmox
    services.qemuGuest.enable = lib.mkDefault true;

    boot.growPartition = lib.mkDefault true;

    # Allow remote updates with flakes and non-root users
    nix.settings.trusted-users = [ "root" "@wheel" ];
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # Some sane packages we need on every system
    environment.systemPackages = with pkgs; [
      vim  # for emergencies
      git # for pulling nix flakes
      python3 # for ansible
    ];

    # Don't ask for passwords
    security.sudo.wheelNeedsPassword = false;

    # Enable ssh
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false; # disable password login
        PermitRootLogin = "no"; # disable root login
        KbdInteractiveAuthentication = false;
      };
      openFirewall = true;
    };
    programs.ssh.startAgent = true;

    # Default filesystem
    fileSystems."/" = lib.mkDefault {
      device = "/dev/disk/by-label/nixos";
      autoResize = true;
      fsType = "ext4";
    };

    system.stateVersion = lib.mkDefault "24.11";

    systemd.mounts = [{
      where = "/sys/kernel/debug";
      enable = false;
    }];

    # Add user 'adam'
    users.users.adam = {
      isNormalUser = true;
      description = "adam";
      extraGroups = [ "networkmanager" "wheel" ];
      openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOKOdtuCE1P89yiANjzQHFPcaw22+fPci9TcA43D8OtQ krivka.adam@gmail.com"
      ];
      packages = with pkgs; [
      ];
    };
  };
}