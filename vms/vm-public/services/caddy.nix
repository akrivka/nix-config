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
        basicauth * {
          cmg {env.CMG_AUTH_HASH}
        }
        file_server
      '';
    };
  };

  systemd.services.caddy.environment.CMG_AUTH_HASH = "$2a$14$hbn7.kEAh82p0Bk9K2/1s.skOe.O8O/MwMDNF6zMGA2LIDAlQ5wRa";

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}