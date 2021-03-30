{ config, pkgs, ... }:

{
  services.nginx.virtualHosts."grafana.xeserv.us" = {
    locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.grafana.port}";
        proxyWebsockets = true;
    };
  };
}
