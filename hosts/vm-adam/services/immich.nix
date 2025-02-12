{
  config,
  lib,
  pkgs,
  ...
}:

let
  port = 2283;
in
{
  services.immich = {
    enable = true;
    port = port;
  };

  services.caddy.virtualHosts."http://immich.adam2".extraConfig = ''
    reverse_proxy http://[::1]:${toString port}
  '';

}
