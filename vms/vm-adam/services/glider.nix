{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  webPort = 5173;
  temporalPort = 7233;
  temporalUiPort = 8233; # temporal-cli UI port (port + 1000)
  surrealdbPort = 8000; # Default for services.surrealdb
in
{
  imports = [ inputs.glider.nixosModules.default ];

  # ===== Shared NixOS Services =====

  # Temporal dev server (using temporal-cli, same as devenv)
  # https://devenv.sh/services/temporal/
  systemd.services.temporal = {
    description = "Temporal Dev Server";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.temporal-cli}/bin/temporal server start-dev --ip 127.0.0.1 --port ${toString temporalPort} --ui-port ${toString temporalUiPort} --db-filename /var/lib/temporal/temporal.db --namespace default";
      Restart = "on-failure";
      RestartSec = "5s";
      StateDirectory = "temporal";
      # Run as a dedicated user for security
      DynamicUser = true;
    };
  };

  # SurrealDB
  services.surrealdb = {
    enable = true;
    port = surrealdbPort;
    extraFlags = [
      "--user"
      "root"
      "--pass"
      "root"
    ]; # Or use secrets
  };

  # Workaround for sysinfo crate panic in LXC containers
  # https://github.com/NixOS/nixpkgs/issues/441978
  # SurrealDB needs /proc access to read cgroup memory limits
  systemd.services.surrealdb.serviceConfig = {
    ProcSubset = lib.mkForce "all";
    ProtectProc = lib.mkForce "default";
  };

  # ===== Glider Application =====

  services.glider = {
    enable = true;
    port = webPort;
    dataDir = "/data/Adam/Services/glider";
    environmentFile = "/data/Adam/Services/glider/secrets.env";

    package = {
      web = inputs.glider.packages.${pkgs.system}.glider-web;
      operator = inputs.glider.packages.${pkgs.system}.glider-operator;
    };

    surrealdb = {
      url = "ws://localhost:${toString surrealdbPort}";
      namespace = "glider";
      database = "glider";
    };

    temporal = {
      address = "localhost:${toString temporalPort}";
      taskQueue = "glider-tasks";
    };

    # Temporal UI is now provided by temporal-cli dev server
    temporalUi.enable = false;
  };

  # ===== Caddy Reverse Proxy =====

  services.caddy.virtualHosts = {
    "http://glider.adam".extraConfig = ''
      reverse_proxy http://0.0.0.0:${toString webPort}
    '';
    "http://temporal-ui.adam".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString temporalUiPort}
    '';
    # Temporal frontend is gRPC (HTTP/2). Terminate TLS on Caddy and proxy
    # upstream using h2c (HTTP/2 cleartext) to the local Temporal server.
    "temporal.adam".extraConfig = ''
      tls internal
      reverse_proxy 127.0.0.1:${toString temporalPort} {
        transport http {
          versions h2c
        }
      }
    '';
    # SurrealDB exposed for remote Surrealist connection from laptop
    "http://surrealdb.adam".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString surrealdbPort}
    '';
  };
}
