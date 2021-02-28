{ pkgs, ... }:

let
  port = 38471;
  secrets = import ./secret/caddy.nix;
  config = pkgs.writeTextFile {
    name = "Caddyfile";
    text = ''
      when-then-zen.christine.website:${toString port} {
          tls off
          errors syslog

          root /srv/http/when-then-zen.christine.website

          internal /README.md
          internal /templates
          internal /LICENSE
          internal /Caddyfile

          ext .md

          browse /bonus
          browse /meditation /srv/http/when-then-zen.christine.website/templates/index.html
          browse /skills /srv/http/when-then-zen.christine.website/templates/index.html

          markdown / {
                  template templates/page.html
          }
      }

      xena.greedo.xeserv.us:${toString port} {
          tls off
          errors syslog

          header / X-Clacks-Overhead "GNU Ashlynn"

          root /srv/http/xena.greedo.xeserv.us
          markdown / {
                  template blog templates/blog.html
                  template index templates/index.html
          }

          browse
      }

      xn--u7hz981o.ws:${toString port} {
          tls off
          errors syslog

          header / X-Clacks-Overhead "GNU Ashlynn"

          internal /templates

          root /srv/http/xn--u7hz981o.ws
          markdown / {
              template index templates/index.html
              template page templates/page.html
          }
      }
    '';
  };
in {
  services.nginx.virtualHosts = {
    "when-then-zen.christine.website" = {
      locations."/" = { proxyPass = "http://127.0.0.1:${toString port}"; };
      forceSSL = true;
      useACMEHost = "christine.website";
    extraConfig = ''
      access_log /var/log/nginx/when-then-zen.access.log;
    '';
    };

    "xena.greedo.xeserv.us" = {
      locations."/".proxyPass = "http://127.0.0.1:${toString port}";
      forceSSL = true;
      useACMEHost = "xeserv.us";
    extraConfig = ''
      access_log /var/log/nginx/xenafiles.access.log;
    '';
    };

    "xn--u7hz981o.ws" = {
      locations."/".proxyPass = "http://127.0.0.1:${toString port}";
      forceSSL = true;
      useACMEHost = "xn--u7hz981o.ws";
    };
  };

  services.cfdyndns.records =
    [ "when-then-zen.christine.website" "xena.greedo.xeserv.us" "xn--u7hz981o.ws" ];

  systemd.services.caddy = {
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      User = "nginx";
      Group = "within";
      Restart = "on-failure";
      RestartSec = "30s";
    };

    script = ''
      exec ${pkgs.x.caddy}/bin/caddy -conf ${config} -port ${
        toString port
      } -agree
    '';
  };
}
