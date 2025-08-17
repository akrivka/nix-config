{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.caddy = {
    enable = true;

    virtualHosts.":80".extraConfig = ''
      respond "Hello from vm-public"
    '';

    virtualHosts."http://cmg.akrivka.com" = {
      extraConfig = ''
        root * /var/www/cmg.akrivka.com
        file_server
      '';
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}