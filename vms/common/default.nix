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
    (fetchTarball "https://github.com/nix-community/nixos-vscode-server/tarball/master")
  ];

  # Allow remote updates with flakes and non-root users
  nix.settings.trusted-users = [
    "root"
    "@wheel"
  ];
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Don't ask for passwords
  security.sudo.wheelNeedsPassword = false;

  # Enable ssh
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false; # disable password login
      KbdInteractiveAuthentication = false;
    };
    openFirewall = true;
  };
  programs.ssh.startAgent = true;

  # Some random fix
  systemd.mounts = [
    {
      where = "/sys/kernel/debug";
      enable = false;
    }
  ];

  # Some sane packages we need on every system
  environment.systemPackages = with pkgs; [
    man # manual pages
    vim # for emergencies
    git # for pulling nix flakes
    nixfmt-rfc-style # for formatting in SSH sessions
    just
    rsync
  ];

  # Enable VSCode server for all VMs
  services.vscode-server.enable = true;

}
