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
    stateDir = "/home/adam/Adam/Services/gitea";
  };

  services.caddy.virtualHosts."http://git.adam".extraConfig = ''
    reverse_proxy :${toString port}
  '';
}
