{ config, pkgs, ... }:

{
  systemd.services = {
    comicchat-server = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = { DynamicUser = true; };
      script = ''
        cd ${pkgs.github.com.Xe.comicchat}/libexec/comicchat/deps/comicchat
        ${pkgs.nodejs}/bin/node server/server.js
      '';
    };

    comicchat-relay = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = { DynamicUser = true; };
      script = ''
        cd ${pkgs.github.com.Xe.comicchat}/libexec/comicchat/deps/comicchat
        ${pkgs.nodejs}/bin/node relay/relay.js
      '';
    };
  };

  services.cfdyndns.records = [ "comicchat.christine.website" "comicchat-ws.christine.website" ];

  services.nginx.virtualHosts."comicchat" = {
    serverName = "comicchat.christine.website";
    locations."/" = {
      extraConfig = ''
        set $args $args&server=wss:///ws;
      '';
      root = "${pkgs.github.com.Xe.comicchat}/libexec/comicchat/deps/comicchat/client";
    };
    locations."/ws" = {
      proxyPass = "http://127.0.0.1:8084";
      proxyWebsockets = true;
    };
    forceSSL = true;
    useACMEHost = "christine.website";
    extraConfig = ''
      access_log /var/log/nginx/comicchat.access.log;
    '';
  };
}
