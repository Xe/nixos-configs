{ config, pkgs, ... }:

let
  domain = name: "irc-${name}.lufta.cetacean.club";
  vhost = { domain, port, ... }: {
    forceSSL = true;
    locations."^~ /weechat" = {
      proxyPass = "http://127.0.0.1:${toString port}";
      proxyWebsockets = true;
    };
    locations."/" = { root = pkgs.glowing-bear; };
    useACMEHost = "cetacean.club";
  };
  cadey = domain "cadey";
  mai = domain "mai";
in {
  services.cfdyndns.records = [ cadey mai ];

  services.nginx.virtualHosts = {
    "${cadey}" = vhost {
      domain = cadey;
      port = 28945;
    };

    "${mai}" = vhost {
      domain = mai;
      port = 28946;
    };
  };
}
