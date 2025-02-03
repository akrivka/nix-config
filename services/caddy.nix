{ config, pkgs, ... }:

{
  services.caddy = {
    enable = true;
    package = pkgs.caddy;

    config = ''
      :80 {
        root * /var/www/html
        file_server
      }
    '';

    virtualHosts."immich.adam".extraConfig = ''
      reverse_proxy :2283
    '';
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}