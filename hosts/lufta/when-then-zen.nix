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
    '';
  };
in {
  services.nginx.virtualHosts."when-then-zen.christine.website" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString port}";
      extraConfig = "proxy_set_header Host $host;";
    };
    forceSSL = true;
    useACMEHost = "christine.website";
  };

  services.cfdyndns.records = [ "when-then-zen.christine.website" ];

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
