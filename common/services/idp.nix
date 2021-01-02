{ config, pkgs, lib, ... }:

with lib;

let cfg = config.within.services.idp;
in {
  options.within.services.idp = {
    enable = mkEnableOption "Enables my IndieAuth IDP service";

    domain = mkOption {
      type = types.str;
      default = "idp.christine.website";
      example = "idp.within.website";
      description =
        "The domain name that nginx should check against for HTTP hostnames";
    };

    port = mkOption {
      type = types.int;
      default = 57438;
      example = 9001;
      description =
        "The port number idp should listen on for HTTP traffic";
    };
  };

  config = mkIf cfg.enable {
    users.users.idp = {
      createHome = true;
      description = "idp.christine.website";
      isSystemUser = true;
      group = "within";
      home = "/srv/within/idp";
    };

    systemd.services.idp = {
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User = "idp";
        Group = "within";
        Restart = "on-failure";
        WorkingDirectory = "/srv/within/idp";
        RestartSec = "30s";
      };

      script = let ww = pkgs.x.idp;
      in ''
        exec ${ww}/bin/idp -port=${toString cfg.port} -otp-secret=${builtins.readFile ./secrets/idp.secret}
      '';
    };

    services.cfdyndns.records = [ "${cfg.domain}" ];

    services.nginx.virtualHosts."idp" = {
      serverName = "${cfg.domain}";
      locations."/".proxyPass = "http://127.0.0.1:${toString cfg.port}";
      forceSSL = true;
      useACMEHost = "christine.website";
    };
  };
}
