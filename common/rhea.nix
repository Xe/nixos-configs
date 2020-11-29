{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.cadey.rhea;

  files = types.submodule {
    options = {
      root = mkOption {
        type = types.str;
        example = "/srv/gemini/cetacean.club";
        description = "gemini root";
      };

      userPaths = mkEnableOption "Enables ~user for ~user/public_gemini";
    };
  };

  filesToJSON = files: {
    root = files.root;
    user_paths = files.userPaths;
  };

  site = types.submodule {
    options = {
      domain = mkOption {
        type = types.str;
        example = "cetacean.club";
        description = "domain name for this site";
      };

      certPath = mkOption {
        type = types.str;
        example = "/srv/within/certs/cetacean.club/cert.pem";
        description = "certificate path";
      };

      keyPath = mkOption {
        type = types.str;
        example = "/srv/within/keys/cetacean.club/key.pem";
        description = "key path";
      };

      files = mkOption {
        type = files;
        description = "files to serve for this site";
      };
    };
  };

  siteToJSON = site: {
    domain = site.domain;
    cert_path = site.certPath;
    key_path = site.keyPath;
    files = if site != null then (filesToJSON site.files) else null;
  };

  configToJSON = cfg: {
    port = cfg.port;
    http_port = cfg.httpPort;
    sites = map siteToJSON cfg.sites;
  };

in {
  options.cadey.rhea = {
    enable = mkEnableOption "Rhea gemini server";

    package = mkOption {
      type = types.package;
      default = pkgs.within.rhea;
      description = "rhea package to use";
    };

    port = mkOption {
      type = types.port;
      default = 1965;
      description = "port to serve Gemini on";
    };

    httpPort = mkOption {
      type = types.port;
      default = 23818;
      description = "port to serve prometheus metrics (http) on";
    };

    sites = mkOption {
      type = types.listOf site;
      description = "gemini sites to serve on this machine";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.rhea = {
      description = "Rhea Gemini server";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/rhea -config ${
            builtins.toFile "config.json" (builtins.toJSON (configToJSON cfg))
          }";
        ProtectHome = "read-only";
        Restart = "on-failure";
        Type = "notify";
      };
    };
  };
}
