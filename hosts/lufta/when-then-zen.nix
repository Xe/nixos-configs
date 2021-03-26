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
  services.fcgiwrap.enable = true;
  services.nginx.virtualHosts = {
    "home.cetacean.club" = {
      locations."/front".extraConfig = ''
        root /tmp;
        fastcgi_param   QUERY_STRING            $query_string;
        fastcgi_param   REQUEST_METHOD          $request_method;
        fastcgi_param   CONTENT_TYPE            $content_type;
        fastcgi_param   CONTENT_LENGTH          $content_length;

        fastcgi_param   PATH_INFO               $fastcgi_path_info;
        fastcgi_param   PATH_TRANSLATED         $document_root$fastcgi_path_info;
        fastcgi_param   REQUEST_URI             $request_uri;
        fastcgi_param   DOCUMENT_URI            $document_uri;
        fastcgi_param   DOCUMENT_ROOT           /srv/http/home.cetacean.club;
        fastcgi_param   SERVER_PROTOCOL         $server_protocol;

        fastcgi_param   GATEWAY_INTERFACE       CGI/1.1;
        fastcgi_param   SERVER_SOFTWARE         nginx/$nginx_version;

        fastcgi_param   REMOTE_ADDR             $remote_addr;
        fastcgi_param   REMOTE_PORT             $remote_port;
        fastcgi_param   SERVER_ADDR             $server_addr;
        fastcgi_param   SERVER_PORT             $server_port;
        fastcgi_param   SERVER_NAME             $server_name;

        fastcgi_param   HTTPS                   $https;

        # PHP only, required if PHP was built with --enable-force-cgi-redirect
        fastcgi_param   REDIRECT_STATUS         200;
        fastcgi_param MI_TOKEN ${builtins.readFile ./secret/mi-token};
        fastcgi_param SCRIPT_FILENAME /srv/http/cgi-bin/whoisfront;
        fastcgi_pass unix:/run/fcgiwrap.sock;
      '';
      forceSSL = true;
      useACMEHost = "cetacean.club";
    extraConfig = ''
      access_log /var/log/nginx/home.cetacean.club.access.log;
    '';
    };

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
    [ "when-then-zen.christine.website" "xena.greedo.xeserv.us" "xn--u7hz981o.ws" "home.cetacean.club" ];

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
