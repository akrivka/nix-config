{
  ...
}:

let
  port = 8085;
in
{
  services.filebrowser = {
    enable = true;
    settings = {
      address = "127.0.0.1";
      port = port;
      root = "/data/Adam";
    };
  };

  services.caddy.virtualHosts."http://filebrowser.adam".extraConfig = ''
    reverse_proxy http://127.0.0.1:${toString port}
  '';
}
