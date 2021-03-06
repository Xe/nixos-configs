{ config, lib, pkgs, ... }:
with lib; {
  options.within.services.tron.enable =
    mkEnableOption "Activates Tron (a furbooru moderation tool)";

  config = mkIf config.within.services.tron.enable {
    # User account
    users.users.tron = {
      createHome = true;
      description = "tulpa.dev/cadey/tron";
      isSystemUser = true;
      group = "within";
      home = "/srv/within/tron";
      extraGroups = [ "keys" ];
    };

    # Secret config
    within.secrets.tron = {
      source = ./secrets/tron.env;
      dest = "/srv/within/tron/.env";
      owner = "tron";
      group = "within";
      permissions = "0640";
    };

    # Service
    systemd.services.tron = {
      wantedBy = [ "multi-user.target" ];
      after = [ "tron-key.service" ];
      wants = [ "tron-key.service" ];

      serviceConfig = {
        User = "tron";
        Group = "within";
        Restart = "on-failure";
        RestartSec = "30s";
      };

      script = let tron = pkgs.within.tron;
      in ''
        export $(cat /srv/within/tron/.env | xargs)
        export REGEXES=${tron}/regexes.dhall
        exec ${tron}/bin/tron
      '';
    };
  };
}
