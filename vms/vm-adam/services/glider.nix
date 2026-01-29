{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.glider.nixosModules.default ];

  # ===== Glider Application =====
  services.glider = {
    enable = true;
    port = 5173;
    dataDir = "/data/Adam/Services/glider";
    environmentFile = "/data/Adam/Services/glider/secrets.env";

    package = {
      web = inputs.glider.packages.${pkgs.system}.glider-web;
      operator = inputs.glider.packages.${pkgs.system}.glider-operator;
    };

    # SurrealDB - just override what differs from defaults
    surrealdb = {
      enable = true;
      # port = 8000;  # default
      # namespace = "glider";  # default
      # database = "glider";  # default
      extraFlags = [
        "--user"
        "root"
        "--pass"
        "root"
      ]; # TODO: use secrets
    };

  };

  # ===== Caddy Reverse Proxy =====
  services.caddy.virtualHosts =
    let
      cfg = config.services.glider;
    in
    {
      "http://glider.adam".extraConfig = ''
        reverse_proxy http://0.0.0.0:${toString cfg.port}
      '';
      "http://surrealdb.adam".extraConfig = ''
        reverse_proxy http://127.0.0.1:${toString cfg.surrealdb.port}
      '';
    };
}
