{ config, pkgs, lib, ... }:

let cfg = config.services.gitea;
in {
  users.users.git = {
    description = "Gitea Service";
    home = cfg.stateDir;
    useDefaultShell = true;
    group = "git";
    isSystemUser = true;
  };
  users.groups.git = { };

  services.gitea = {
    enable = true;
    user = "git";
    domain = "tulpa.dev";
    appName = "${cfg.domain}: git in plurality";
    rootUrl = "https://${cfg.domain}/";
    httpAddress = "127.0.0.1";
    httpPort = 49381;
    settings = {
      server = { SSH_DOMAIN = "ssh.tulpa.dev"; };
      other = { SHOW_FOOTER_VERSION = false; };
    };
    dump.enable = false;
    extraConfig = builtins.readFile ./secret/gitea.ini;
    database.user = "git";
  };

  services.cfdyndns.records = [ "lufta.tulpa.dev" "tulpa.dev" ];

  services.nginx.virtualHosts."lufta.tulpa.dev" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString cfg.httpPort}";
      proxyWebsockets = true;
    };
    forceSSL = true;
    useACMEHost = "tulpa.dev";
  };

  services.nginx.virtualHosts."tulpa.dev" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString cfg.httpPort}";
      proxyWebsockets = true;
    };
    forceSSL = true;
    useACMEHost = "tulpa.dev";
  };
}
