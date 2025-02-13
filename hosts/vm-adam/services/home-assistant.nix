{ config, pkgs, ... }:

let 
  port = 8123;
in 
{
  services.home-assistant = {
    enable = true;
    config = {
      http.server_port = port;
    };
  };

    services.caddy.virtualHosts."http://ha.adam2".extraConfig = ''
    reverse_proxy http://[::1]:${toString port}
  '';

}
