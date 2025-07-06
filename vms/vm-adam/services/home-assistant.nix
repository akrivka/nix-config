{ config, pkgs, ... }:

let
  port = 8123;
in
{
  services.home-assistant = {
    enable = true;
    config = {
      http = {
        server_host = "::1";
        trusted_proxies = [ "::1" ];
        use_x_forwarded_for = true;
      };
    };
  };

  services.caddy.virtualHosts."http://ha.adam".extraConfig = ''
    reverse_proxy http://[::1]:${toString port}
  '';

}
