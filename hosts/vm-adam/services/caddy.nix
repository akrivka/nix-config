{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.caddy = {
    enable = true;
    package = pkgs.caddy;

    virtualHosts.":80".extraConfig = ''
      respond "Hello Nix"
    '';
    virtualHosts."http://immich.adam2".extraConfig = ''
      reverse_proxy http://[::1]:2283
    '';
    virtualHosts."http://syncthing.adam2".extraConfig = ''
      reverse_proxy :8384
    '';
    virtualHosts."http://git.adam2".extraConfig = ''
      reverse_proxy :3000
    '';
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
