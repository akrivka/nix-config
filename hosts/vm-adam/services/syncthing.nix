{
  config,
  lib,
  pkgs,
  ...
}:

let
  port = 8384;
in
{
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    guiAddress = "0.0.0.0:${toString port}";
    settings.gui = {
      user = "adam";
      password = "ahoj";
    };
  };

  services.caddy.virtualHosts."http://syncthing.adam2".extraConfig = ''
    reverse_proxy :${toString port}
  '';
}
