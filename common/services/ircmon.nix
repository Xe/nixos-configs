{ config, lib, pkgs, ... }:
with lib;
let cfg = config.within.services.ircmon;
in {
  options.within.services.ircmon = {
    enable = mkEnableOption "enables IRC monitoring of liberachat";

    sockPath = mkOption rec {
      type = types.str;
      default = "/srv/within/run/ircmon.sock";
      example = default;
      description = "The unix domain socket that xesite should listen on";
    };
  };

  config = mkIf cfg.enable {
    users.users.ircmon = {
      createHome = true;
      description = "github.com/Xe/ircmon";
      isSystemUser = true;
      group = "within";
      home = "/srv/within/ircmon";
      extraGroups = [ "keys" ];
    };

    within.secrets.ircmon = {
      source = ./secrets/ircmon.env;
      dest = "/srv/within/ircmon/.env";
      owner = "ircmon";
      group = "within";
      permissions = "0400";
    };

    systemd.services = {
      ircmon-bot = {
        wantedBy = [ "multi-user.target" ];
        after = [ "ircmon-key.service" ];
        wants = [ "ircmon-key.service" ];
        path = [ pkgs.perl ];

        serviceConfig = {
          User = "ircmon";
          Group = "within";
          Restart = "on-failure";
          WorkingDirectory = "/srv/within/ircmon";
          RestartSec = "30s";
        };

        script = let ircmon = pkgs.github.com.Xe.ircmon;
        in with pkgs.perl532Packages; ''
          exec ${ircmon}/main.pl
        '';
      };
      ircmon-http = {
        wantedBy = [ "multi-user.target" ];
        after = [ "ircmon-bot.service" ];
        wants = [ "ircmon-bot.service" ];
        path = [ pkgs.perl ];

        serviceConfig = {
          User = "ircmon";
          Group = "within";
          Restart = "on-failure";
          WorkingDirectory = "/srv/within/ircmon";
          RestartSec = "30s";
        };

        script = let ircmon = pkgs.github.com.Xe.ircmon;
        in ''
          export SOCKPATH=${cfg.sockPath}
          exec ${ircmon}/cgi.pl
        '';
      };
    };
  };
}
