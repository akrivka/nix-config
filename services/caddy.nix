{ config, pkgs, ... }:

{
  services.caddy = {
    enable = true;
    package = pkgs.caddy;
    

    virtualHosts.":80".extraConfig = ''
      reverse_proxy :2283
    '';
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}