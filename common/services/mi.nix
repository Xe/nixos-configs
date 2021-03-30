{ config, lib, pkgs, ... }:

with lib;

let cfg = config.within.services.mi;
in {
  options.within.services.mi = {
    enable = mkEnableOption "Activates mi (a personal API)";
    useACME = mkEnableOption "Enables ACME for cert stuff";

    port = mkOption {
      type = types.int;
      default = 38288;
      example = 9001;
      description = "The port number mi should listen on for HTTP traffic";
    };

    domain = mkOption {
      type = types.str;
      default = "mi.within.website";
      example = "mi.within.website";
      description =
        "The domain name that nginx should check against for HTTP hostnames";
    };
  };

  config = mkIf cfg.enable {
    users.users.mi = {
      createHome = true;
      description = "github.com/Xe/mi";
      isSystemUser = true;
      group = "within";
      home = "/srv/within/mi";
      extraGroups = [ "keys" ];
    };

    within.secrets.mi = {
      source = ./secrets/mi.toml;
      dest = "/srv/within/mi/Rocket.toml";
      owner = "mi";
      group = "within";
      permissions = "0400";
    };

    systemd.services.mi = {
      wantedBy = [ "multi-user.target" ];
      after = [ "mi-key.service" "systemd-resolved.service" ];
      wants = [ "mi-key.service" "systemd-resolved.service" ];

      serviceConfig = {
        User = "mi";
        Group = "within";
        Restart = "on-failure";
        WorkingDirectory = "/srv/within/mi";
        RestartSec = "30s";
        Type = "notify";
      };

      script = let mi = pkgs.within.mi;
      in ''
        export ROCKET_PORT=${toString cfg.port}
        exec ${mi}/bin/mi-backend
      '';
    };

    systemd.services.mi-package-updater = {
      wantedBy = [ "multi-user.target" ];
      after = [ "mi-key.service" ];
      wants = [ "mi-key.service" ];

      serviceConfig = {
        User = "mi";
        Group = "within";
        WorkingDirectory = "/srv/within/mi";
        Type = "oneshot";
      };

      script = let mi = pkgs.within.mi;
      in ''
        export DATABASE_URL=./mi.db
        exec ${mi}/bin/package_track
      '';

      startAt = "*-*-* 00:00:00"; # daily
    };

    services.nginx.virtualHosts."mi" = {
      serverName = "${cfg.domain}";
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString cfg.port}";
        proxyWebsockets = true;
      };
      forceSSL = cfg.useACME;
      useACMEHost = "within.website";
      extraConfig = ''
        access_log /var/log/nginx/mi.access.log;
      '';
    };

    services.cfdyndns = mkIf cfg.useACME { records = [ "${cfg.domain}" ]; };
  };
}
