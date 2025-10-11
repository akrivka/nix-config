{
  ...
}:

let
  # Linkwarden app port on the host (loopback only)
  port = 3110;
in
{
  services.linkwarden = {
    enable = true;
    port = port;
    storageLocation = "/data/Adam/Services/linkwarden";
    environmentFile = "./linkwarden.env";
  };

  # Caddy reverse proxy for local domain
  services.caddy.virtualHosts."http://linkwarden.adam".extraConfig = ''
    reverse_proxy localhost:${toString port}
  '';
}
