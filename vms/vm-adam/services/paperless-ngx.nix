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
  services.paperless = {
    enable = true;
    port = port;
  };

  services.caddy.virtualHosts."http://paperless.adam".extraConfig = ''
    reverse_proxy http://[::1]:${toString port}
  '';
}
