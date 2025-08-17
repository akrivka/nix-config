{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.cloudflared = {
    enable = true;
    tunnels = {
      "cmg-akrivka" = {
        default = "http_status:404";
        credentialsFile = "/etc/cloudflared/tunnel-credentials.json";
        ingress = {
          "cmg.akrivka.com" = {
            service = "http://localhost:80";
          };
        };
      };
    };
  };

  # Note: You'll need to manually create the tunnel and add credentials
  # 1. cloudflared tunnel create cmg-akrivka
  # 2. cloudflared tunnel route dns cmg-akrivka cmg.akrivka.com
  # 3. Copy the credentials JSON to /etc/cloudflared/tunnel-credentials.json
  
  environment.systemPackages = with pkgs; [
    cloudflared
  ];
}