{ config, lib, pkgs, ... }:
with lib;

let cfg = config.within.services.snoo2nebby; in {
  options.within.services.snoo2nebby = {
    enable = mkEnableOption "enables snoo2nebby for crossposting from reddit to Discord";
    subreddit = mkOption {
      type = types.str;
      default = "tulpas";
      description = "the subreddit name to monitor (the foo of /r/foo)";
    };
  };

  config = mkIf cfg.enable {
    users.users.snoo2nebby = {
      createHome = true;
      description = "tulpa.dev/cadey/snoo2nebby";
      isSystemUser = true;
      group = "within";
      home = "/srv/within/snoo2nebby";
      extraGroups = [ "keys" ];
    };

    within.secrets.snoo2nebby = {
      source = ./secrets/snoo2nebby.whurl.txt;
      dest = "/srv/within/snoo2nebby/whurl.txt";
      owner = "snoo2nebby";
      group = "within";
      permissions = "0640";
    };

    systemd.services.snoo2nebby = {
      wantedBy = [ "multi-user.target" ];
      after = [ "snoo2nebby-key.service" ];
      wants = [ "snoo2nebby-key.service" ];

      serviceConfig = {
        User = "snoo2nebby";
        Group = "within";
        Restart = "on-failure";
        WorkingDirectory = "/srv/within/snoo2nebby";
        RestartSec = "30s";
      };

      script = let pkg = pkgs.tulpa.dev.cadey.snoo2nebby;
      in ''
        exec ${pkg}/bin/snoo2nebby -webhook-file /srv/within/snoo2nebby/whurl.txt -subreddit "${cfg.subreddit}"
      '';
    };
  };
}
