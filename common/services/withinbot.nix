{ config, lib, pkgs, ... }:
with lib; {
  options.within.services.withinbot.enable =
    mkEnableOption "Activates Withinbot (the furryhole chatbot)";

  config = mkIf config.within.services.withinbot.enable {
    users.users.withinbot = {
      createHome = true;
      description = "github.com/Xe/withinbot";
      isSystemUser = true;
      group = "within";
      home = "/srv/within/withinbot";
      extraGroups = [ "keys" ];
    };

    deployment.keys.withinbot = {
      text = builtins.readFile ./secrets/withinbot.env;
      user = "withinbot";
      group = "within";
      permissions = "0640";
    };

    systemd.services.withinbot = {
      wantedBy = [ "multi-user.target" ];
      after = [ "withinbot-key.service" ];
      wants = [ "withinbot-key.service" ];

      serviceConfig = {
        User = "withinbot";
        Group = "within";
        Restart = "on-failure";
        WorkingDirectory = "/srv/within/withinbot";
        RestartSec = "30s";
      };

      script = let withinbot = pkgs.within.withinbot;
      in ''
        export $(grep -v '^#' /run/keys/withinbot | xargs)
        export CAMPAIGN_FOLDER=${withinbot}/campaigns
        exec ${withinbot}/bin/withinbot
      '';
    };
  };
}
