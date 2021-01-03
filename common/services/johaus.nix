{ config, pkgs, lib, ... }:

with lib;

let cfg = config.within.services.johaus;
in {
  options.within.services.johaus = {
    enable = mkEnableOption "Enables the within.website import redirector";

    domain = mkOption {
      type = types.str;
      default = "johaus.xeserv.us";
      example = "johaus.xeserv.us";
      description =
        "The domain name that nginx should check against for HTTP hostnames";
    };

    port = mkOption {
      type = types.int;
      default = 52338;
      example = 9001;
      description =
        "The port number johaus should listen on for HTTP traffic";
    };
  };

  config = mkIf cfg.enable {
    users.users.johaus = {
      createHome = true;
      description = "la jo'aus";
      isSystemUser = true;
      group = "within";
      home = "/srv/within/johaus";
    };

    systemd.services.johaus = {
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User = "johaus";
        Group = "within";
        Restart = "on-failure";
        WorkingDirectory = "/srv/within/johaus";
        RestartSec = "30s";
      };

      script = let ww = pkgs.x.johaus;
      in ''
        exec ${ww}/bin/johaus -port=${toString cfg.port}
      '';
    };

    services.cfdyndns.records = [ "${cfg.domain}" ];

    services.nginx.virtualHosts."johaus" = {
      serverName = "${cfg.domain}";
      locations."/".proxyPass = "http://127.0.0.1:${toString cfg.port}";
      forceSSL = false;
      useACMEHost = "xeserv.us";
    };
  };
}
