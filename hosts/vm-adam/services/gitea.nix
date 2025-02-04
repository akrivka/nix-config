{
  config,
  lib,
  pkgs,
  ...
}:

let
  port = 3000;
in
{
  services.gitea = {
    enable = true;
    settings.server.HTTP_PORT = port;
  };

  services.caddy.virtualHosts."http://git.adam2".extraConfig = ''
    reverse_proxy :${port}
  '';
}
