{ config, pkgs, lib, ... }:

with lib;

let cfg = config.within.services.goproxy;
in {
  options.within.services.goproxy = {
    enable = mkEnableOption "Enables Go module cache support";
    useACME = mkEnableOption "Enables ACME for cert stuff";

    domain = mkOption {
      type = types.str;
      default = "goproxy.akua";
      example = "cache.greedo.xeserv.us";
      description =
        "The domain name that nginx should check against for HTTP hostnames";
    };

    port = mkOption {
      type = types.int;
      default = 38288;
      example = 9001;
      description = "The port number mi should listen on for HTTP traffic";
    };

    host = mkOption {
      type = types.str;
      default = "127.0.0.1";
      example = "0.0.0.0";
      description = "The host goproxy should bind to";
    };

    upstream = mkOption {
      type = types.str;
      default = "https://proxy.golang.org";
      example = "https://proxy.golang.org";
      description = "where the go module cache should live on disk";
    };

    exclude = mkOption {
      type = types.str;
      default = "";
      example = "github.com/mycorp";
      description = "GOPRIVATE for goproxy";
    };

    cacheDir = mkOption {
      type = types.str;
      default = "/srv/within/goproxy/cache";
      example = "/var/lib/goproxy";
      description = "where the go module cache should live on disk";
    };
  };

  config = mkIf cfg.enable {
    users.users.goproxy = {
      createHome = true;
      description = "github.com/goproxyio/goproxy";
      isSystemUser = true;
      group = "within";
      home = "/srv/within/goproxy";
    };

    systemd.services.goproxy = {
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User = "goproxy";
        Group = "within";
        Restart = "on-failure";
        WorkingDirectory = "/srv/within/goproxy";
        RestartSec = "30s";
      };

      script = let gp = pkgs.github.com.goproxyio.goproxy;
      in ''
        exec ${gp}/bin/goproxy -cacheDir="${cfg.cacheDir}" -exclude="${cfg.exclude}" -listen="${cfg.host}:${
          toString cfg.port
        }" -proxy ${cfg.upstream}
      '';
    };

    services.cfdyndns = mkIf cfg.useACME { records = [ "${cfg.domain}" ]; };

    services.nginx.virtualHosts."goproxy" = {
      serverName = "${cfg.domain}";
      locations."/".proxyPass = "http://127.0.0.1:${toString cfg.port}";
      forceSSL = cfg.useACME;
      useACMEHost = "xeserv.us";
      extraConfig = ''
        access_log /var/log/nginx/goproxy.access.log;
      '';
    };
  };
}
