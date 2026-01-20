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
  nix.settings = {
    substituters = [
      "https://adam-cache.cachix.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "adam-cache.cachix.org-1:BXUDoC85M8jHPYkbNpiSUD6XIF3O58XgPk6szwNghKA="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    trusted-users = [
      "root"
      "@wheel"
    ];
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nixpkgs.config.allowUnfree = true;

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
    just
    rsync
    nixd
    nil
    nixfmt
    cachix
    tmux
    screen
  ];

  # Enable VSCode server for all VMs
  services.vscode-server.enable = true;

}
