{
  ...
}:

let
  port = 9000;
in
{
  services.mealie = {
    enable = true;
    port = port;
    settings = { };
  };

  services.caddy.virtualHosts."http://mealie.adam".extraConfig = ''
    reverse_proxy :${toString port}
  '';
}
