{ config, pkgs, lib, ... }:

with lib;

let cfg = config.within.services.oragono;
in {
  options.within.services.oragono = {
    enable = mkEnableOption "Enables the Oragono IRCd";
  };

  config = mkIf cfg.enable {
    users.users.oragono = {
      createHome = true;
      description = "github.com/oragono/oragono";
      isSystemUser = true;
      group = "within";
      home = "/srv/within/oragono";
      extraGroups = [ "keys" ];
    };

    within.secrets.oragono = {
      source = ./secrets/oragono.yaml;
      dest = "/srv/within/oragono/oragono.yaml";
      owner = "oragono";
      group = "within";
      permissions = "0400";
    };

    systemd.services.oragono = {
      wantedBy = [ "multi-user.target" ];
      after = [ "oragono-key.service" ];
      wants = [ "oragono-key.service" ];

      serviceConfig = {
        User = "oragono";
        Group = "within";
        Restart = "on-failure";
        WorkingDirectory = "/srv/within/oragono";
        RestartSec = "30s";
      };

      script = let ora = pkgs.github.com.oragono.oragono;
      in ''
        rm ircd.yaml ||:
        ln -s /run/keys/oragono ircd.yaml
        ${ora}/bin/oragono mkcerts ||:
        ${ora}/bin/oragono --conf=/srv/within/oragono/oragono.yaml run
      '';
    };

    services.tor.relay.onionServices = {
      "oragono" = {
        version = 3;
        map = [6667 23181];
      };
    };

    services.mysql = {
      ensureUsers = [{
        name = "oragono";
        ensurePermissions = { "oragono_history.*" = "ALL PRIVILEGES"; };
      }];
      ensureDatabases = [ "oragono_history" ];
    };
  };
}
