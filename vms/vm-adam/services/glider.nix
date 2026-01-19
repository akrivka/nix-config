{ config, pkgs, inputs, ... }:
let
  webPort = 5173;
  temporalUiPort = 8080;
  surrealdbPort = 8000; # Default for services.surrealdb
in
{
  imports = [ inputs.glider.nixosModules.default ];

  # ===== Shared NixOS Services =====

  # PostgreSQL (for Temporal backend)
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "temporal" "temporal_visibility" ];
    ensureUsers = [{
      name = "temporal";
      ensureDBOwnership = true;
    }];
  };

  # Temporal server
  services.temporal = {
    enable = true;
    settings = {
      # Minimal config - uses PostgreSQL backend
      persistence = {
        defaultStore = "postgres-default";
        visibilityStore = "postgres-visibility";
        datastores = {
          postgres-default = {
            sql = {
              pluginName = "postgres12";
              databaseName = "temporal";
              connectAddr = "/run/postgresql";
              user = "temporal";
            };
          };
          postgres-visibility = {
            sql = {
              pluginName = "postgres12";
              databaseName = "temporal_visibility";
              connectAddr = "/run/postgresql";
              user = "temporal";
            };
          };
        };
      };
      global.membership = {
        maxJoinDuration = "30s";
        broadcastAddress = "127.0.0.1";
      };
      services = {
        frontend.rpc.grpcPort = 7233;
      };
    };
  };

  # SurrealDB
  services.surrealdb = {
    enable = true;
    port = surrealdbPort;
    dbPath = "rocksdb:///var/lib/surrealdb/";
    extraFlags = [ "--user" "root" "--pass" "root" ]; # Or use secrets
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
      address = "localhost:7233";
      taskQueue = "glider-tasks";
    };

    temporalUi = {
      enable = true;
      port = temporalUiPort;
    };
  };

  # ===== Caddy Reverse Proxy =====

  services.caddy.virtualHosts = {
    "http://glider.adam".extraConfig = ''
      reverse_proxy http://[::1]:${toString webPort}
    '';
    "http://temporal.adam".extraConfig = ''
      reverse_proxy http://[::1]:${toString temporalUiPort}
    '';
    # SurrealDB exposed for remote Surrealist connection from laptop
    "http://surrealdb.adam".extraConfig = ''
      reverse_proxy http://[::1]:${toString surrealdbPort}
    '';
  };
}
