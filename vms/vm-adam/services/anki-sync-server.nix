{
  config,
  lib,
  pkgs,
  ...
}:

let
  port = 27701;
in
{
  services.anki-sync-server = {
    enable = true;
    port = port;
    #baseDirectory = "/data/Adam/Services/anki";
    users = [
      {
        username = "adam";
        password = "password";
      }
    ];
  };

  services.caddy.virtualHosts."http://anki.adam2".extraConfig = ''
    reverse_proxy http://[::1]:${toString port}
  '';

}
