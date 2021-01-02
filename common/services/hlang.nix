{ config, pkgs, lib, ... }:

with lib;

let cfg = config.within.services.hlang;
in {
  options.within.services.hlang = {
    enable = mkEnableOption "Enables the H programming language";
    useACME = mkEnableOption "Enables ACME for cert stuff";

    domain = mkOption {
      type = types.str;
      default = "hlang.akua";
      example = "h.christine.website";
      description =
        "The domain name that nginx should check against for HTTP hostnames";
    };

    port = mkOption {
      type = types.int;
      default = 38288;
      example = 9001;
      description = "The port number hlang should listen on for HTTP traffic";
    };
  };

  config = mkIf cfg.enable {
    users.users.hlang = {
      createHome = true;
      description = "tulpa.dev/cadey/hlang";
      isSystemUser = true;
      group = "within";
      home = "/srv/within/hlang";
    };

    systemd.services.hlang = {
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User = "hlang";
        Group = "within";
        Restart = "on-failure";
        WorkingDirectory = "/srv/within/hlang";
        RestartSec = "30s";
      };

      script = let h = pkgs.tulpa.dev.cadey.hlang;
      in ''
        exec ${h}/bin/h -port=${toString cfg.port}" 
      '';
    };

    services.nginx.virtualHosts."hlang" = {
      serverName = "${cfg.domain}";
      locations."/".proxyPass = "http://127.0.0.1:${toString cfg.port}";
    } // mkIf cfg.useACME {
      forceSSL = true;
      enableACME = true;
    };
  };
}
