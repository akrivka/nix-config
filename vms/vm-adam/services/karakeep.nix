{
  ...
}:

let
  port = 3000;
in
{
  services.karakeep = {
    enable = true;
    extraEnvironment = {
      PORT = toString port;
    };
  };

  services.caddy.virtualHosts."http://karakeep.adam".extraConfig = ''
    reverse_proxy http://127.0.0.1:${toString port}
  '';
}
