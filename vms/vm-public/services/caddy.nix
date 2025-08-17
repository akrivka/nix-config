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
          haleluja {env.CMG_AUTH_HASH}
        }
        file_server
      '';
    };
  };

  systemd.services.caddy.environment.CMG_AUTH_HASH = "$2a$14$PGcn.Zsj0hgRxfrpwo3d6us0CYTYFn1UH5fPK68Oe5y2qmaOn0.r6";

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}