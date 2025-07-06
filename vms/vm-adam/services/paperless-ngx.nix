{
  config,
  lib,
  pkgs,
  ...
}:

let
  port = 8000;
in
{
  services.paperless-ngx = {
    enable = true;
    port = port;
  };

  services.caddy.virtualHosts."http://paperless-ngx.adam".extraConfig = ''
    reverse_proxy http://[::1]:${toString port}
  '';
}
