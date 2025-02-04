{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.caddy = {
    enable = true;
    package = pkgs.caddy;

    virtualHosts.":80".extraConfig = ''
      respond "Hello from vm-adam"
    '';
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
