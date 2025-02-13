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
    group = "wheel";
    settings = {
      gui = {
        user = "adam";
        password = "password";
      };
      folders = {
        "Drive" = {
          path = "/data/Adam/Drive";
          devices = [ ];
        };
      };
    };
  };

  services.caddy.virtualHosts."http://syncthing.adam2".extraConfig = ''
    reverse_proxy :${toString port}
  '';
}
