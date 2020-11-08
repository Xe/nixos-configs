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
    deployment.keys.tron = {
      text = builtins.readFile ./secrets/tron.env;
      user = "tron";
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
      };

      script = let tron = pkgs.within.tron;
      in ''
        export REGEXES=${tron}/regexes.dhall
        exec ${tron}/bin/tron
      '';
    };
  };
}
