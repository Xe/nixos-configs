{ config, lib, pkgs, ... }:

with lib; {
  options.within.services.mi = {
    enable = mkEnableOption "Activates mi (a personal API)";

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

  config = mkIf config.within.services.mi.enable {
    users.users.mi = {
      createHome = true;
      description = "github.com/Xe/mi";
      isSystemUser = true;
      group = "within";
      home = "/srv/within/mi";
      extraGroups = [ "keys" ];
    };

    deployment.keys.mi = {
      text = builtins.readFile ./secrets/mi.toml;
      user = "mi";
      group = "within";
      permissions = "0640";
    };

    systemd.services.mi = {
      wantedBy = [ "multi-user.target" ];
      after = [ "mi-key.service" ];
      wants = [ "mi-key.service" ];

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
        rm Rocket.toml ||:
        ln -s /run/keys/mi ./Rocket.toml
        export ROCKET_PORT=${toString config.within.services.mi.port}
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
      };

      script = let mi = pkgs.within.mi;
      in ''
        export DATABASE_URL=./mi.db
        exec ${mi}/bin/package_track
      '';

      startAt = "*-*-* 00:00:00"; # daily
    };

    services.nginx.virtualHosts."mi" = {
      serverName = "${config.within.services.mi.domain}";
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.within.services.mi.port}";
        proxyWebsockets = true;
      };
    };
  };
}
