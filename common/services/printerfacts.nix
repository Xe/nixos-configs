{ config, lib, pkgs, ... }:
with lib;
let cfg = config.within.services.printerfacts;
in {
  options.within.services.printerfacts = {
    enable = mkEnableOption "Activates the printerfacts server";

    port = mkOption {
      type = types.int;
      default = 28318;
      example = 9001;
      description = "The port number printerfacts should listen on for HTTP traffic";
    };

    domain = mkOption {
      type = types.str;
      default = "printerfacts.akua";
      example = "printerfacts.cetacean.club";
      description =
        "The domain name that nginx should check against for HTTP hostnames";
    };
  };

  config = mkIf cfg.enable {
    users.users.printerfacts = {
      createHome = true;
      description = "tulpa.dev/cadey/printerfacts";
      isSystemUser = true;
      group = "within";
      home = "/srv/within/printerfacts";
      extraGroups = [ "keys" ];
    };

    deployment.keys.printerfacts = {
      text = builtins.readFile ./secrets/printerfacts.env;
      user = "printerfacts";
      group = "within";
      permissions = "0400";
    };

    systemd.services.printerfacts = {
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User = "printerfacts";
        Group = "within";
        Restart = "on-failure";
        WorkingDirectory = "/srv/within/printerfacts";
        RestartSec = "30s";

        # Security
        CapabilityBoundingSet = "";
        DeviceAllow = [];
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

      script = let site = pkgs.tulpa.dev.cadey.printerfacts; in ''
        export PORT=${toString cfg.port}
        export DOMAIN=${toString cfg.domain}
        cd ${site}
        exec ${site}/bin/printerfacts
      '';
    };

    services.nginx.virtualHosts."printerfacts" = {
      serverName = "${cfg.domain}";
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString cfg.port}";
        proxyWebsockets = true;
      };
    };
  };
}
