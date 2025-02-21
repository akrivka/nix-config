{
  config,
  lib,
  pkgs,
  ...
}:

let
  port = 8384;
in
{
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    guiAddress = "0.0.0.0:${toString port}";
    group = "wheel";

    overrideDevices = false;
    overrideFolders = false;
    
    settings = {
      gui = {
        user = "adam";
        password = "password";
      };
      devices = {
        "Legion5" = { id = "GI5Q2QK-KG4CBII-FZC3EN3-WVTMAZI-BVBQHDY-EVRNI4U-RQGCSFO-SYYDKQF"; };
        "MacbookProM1" = { id = "CLBZ4GN-BWVG2VM-I7WXKUT-EMVN64J-WS6OKMT-ITP3HFH-JR4WNQT-ATAANA5"; };
      };
    };
  };

  services.caddy.virtualHosts."http://syncthing.adam2".extraConfig = ''
    reverse_proxy :${toString port}
  '';
}
