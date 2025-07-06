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
    settings = builtins.fromJSON (builtins.readFile ./immich.json);
    mediaLocation = "/data/Adam/Services/immich";
    environment = {
      LIBRARY_LOCATION = "/data/Adam/Photos";
    };
  };

  services.caddy.virtualHosts."http://immich.adam".extraConfig = ''
    reverse_proxy http://[::1]:${toString port}
  '';

}
