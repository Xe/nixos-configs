{ config, lib, pkgs, ... }:
with lib;
let cfg = config.within.services.xesite;
in {
  options.within.services.xesite = {
    enable = mkEnableOption "Activates my personal website";
    useACME = mkEnableOption "Enables ACME for cert stuff";

    port = mkOption {
      type = types.port;
      default = 32837;
      example = 9001;
      description = "The port number xesite should listen on for HTTP traffic";
    };

    domain = mkOption {
      type = types.str;
      default = "xesite.akua";
      example = "christine.website";
      description =
        "The domain name that nginx should check against for HTTP hostnames";
    };
  };

  config = mkIf cfg.enable {
    users.users.xesite = {
      createHome = true;
      description = "github.com/Xe/site";
      isSystemUser = true;
      group = "within";
      home = "/srv/within/xesite";
      extraGroups = [ "keys" ];
    };

    deployment.keys.xesite = {
      text = builtins.readFile ./secrets/xesite.env;
      user = "xesite";
      group = "within";
      permissions = "0400";
    };

    systemd.services.xesite = {
      wantedBy = [ "multi-user.target" ];
      after = [ "xesite-key.service" "mi.service" ];
      wants = [ "xesite-key.service" "mi.service" ];

      serviceConfig = {
        User = "xesite";
        Group = "within";
        Restart = "on-failure";
        WorkingDirectory = "/srv/within/xesite";
        RestartSec = "30s";

        # Security
        CapabilityBoundingSet = "";
        DeviceAllow = [ ];
        NoNewPrivileges = "true";
        ProtectControlGroups = "true";
        ProtectClock = "true";
        PrivateDevices = "true";
        PrivateUsers = "true";
        ProtectHome = "true";
        ProtectHostname = "true";
        ProtectKernelLogs = "true";
        ProtectKernelModules = "true";
        ProtectKernelTunables = "true";
        ProtectSystem = "true";
        ProtectProc = "invisible";
        RemoveIPC = "true";
        RestrictAddressFamilies = [ "~AF_UNIX" "~AF_NETLINK" ];
        RestrictNamespaces = [
          "CLONE_NEWCGROUP"
          "CLONE_NEWIPC"
          "CLONE_NEWNET"
          "CLONE_NEWNS"
          "CLONE_NEWPID"
          "CLONE_NEWUTS"
          "CLONE_NEWUSER"
        ];
        RestrictSUIDSGID = "true";
        RestrictRealtime = "true";
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "~@reboot"
          "~@module"
          "~@mount"
          "~@swap"
          "~@resources"
          "~@cpu-emulation"
          "~@obsolete"
          "~@debug"
          "~@privileged"
        ];
        UMask = "077";
      };

      script = let site = pkgs.github.com.Xe.site;
      in ''
        export $(grep -v '^#' /run/keys/xesite | xargs)
        export PORT=${toString cfg.port}
        export DOMAIN=${toString cfg.domain}
        cd ${site}
        exec ${site}/bin/xesite
      '';

      postStart = with pkgs; ''
        export $(grep -v '^#' /run/keys/xesite | xargs)
        ${curl}/bin/curl 'https://www.bing.com/ping?sitemap=https://christine.website/sitemap.xml'
        ${curl}/bin/curl 'https://www.google.com/ping?sitemap=https://christine.website/sitemap.xml'
        ${curl}/bin/curl -H "Authorization: $MI_TOKEN" https://mi.within.website/api/blog/refresh -XPOST
      '';
    };

    services.nginx.virtualHosts."xesite" = {
      serverName = "${cfg.domain}";
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString cfg.port}";
        proxyWebsockets = true;
      };
      forceSSL = cfg.useACME;
      useACMEHost = "christine.website";
      extraConfig = ''
        access_log /var/log/nginx/xesite.access.log;
      '';
    };
  };
}
