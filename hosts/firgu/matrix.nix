{ pkgs, ... }:

let
  creds = pkgs.writeTextFile {
    name = "cloudflare.env";
    text = builtins.readFile ../lufta/secret/acme-cf.env;
  };

  extraLegoFlags = [ "--dns.resolvers=8.8.8.8:53" ];

in {
  services.matrix-synapse = {
    enable = true;
    settings = {
      server_name = "within.website";

      enable_metrics = true;
      url_preview_enabled = true;

      max_upload_size = "100M";

      enable_registration = false;

      listeners = [
        {
          bind_addresses = [ "127.0.0.1" "::1" ];
          port = 8448;
          type = "http";
          tls = false;
          x_forwarded = true;
          resources = [{
            compress = false;
            names = [ "client" "federation" ];
          }];
        }
        {
          bind_addresses = [ "100.77.196.9" ];
          port = 8448;
          type = "http";
          tls = false;
          resources = [{
            compress = false;
            names = [ "client" "federation" ];
          }];
        }
        {
          bind_addresses = [ "100.77.196.9" ];
          port = 9000;
          type = "metrics";
          tls = false;
          resources = [ ];
        }
      ];

      registration_requires_token = true;
    };
  };

  services.nginx.virtualHosts = {
    "matrix.within.website" = {
      forceSSL = true;
      useACMEHost = "within.website";

      locations = {
        "/".extraConfig = ''
          return 404;
        '';

        "/_matrix" = { proxyPass = "http://127.0.0.1:8448"; };
      };
    };

    "element.within.website" = {
      forceSSL = true;
      useACMEHost = "within.website";

      root = pkgs.element-web.override {
        conf = {
          default_server_config."m.homeserver" = {
            "base_url" = "https://matrix.within.website";
            "server_name" = "within.website";
          };
          showLabsSettings = true;
        };
      };
    };
  };

  services.postgresql.enable = true;
  services.postgresql.initialScript = pkgs.writeText "synapse-init.sql" ''
    CREATE ROLE "matrix-synapse" WITH LOGIN PASSWORD 'synapse';
    CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
      TEMPLATE template0
      LC_COLLATE = "C"
      LC_CTYPE = "C";
  '';

  security.acme.certs."within.website" = {
    group = "users";
    email = "me@christine.website";
    dnsProvider = "cloudflare";
    credentialsFile = "${creds}";
    extraDomainNames = [ "matrix.within.website" "element.within.website" ];
    inherit extraLegoFlags;
  };
}
