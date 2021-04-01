{ config, lib, pkgs, ... }:
with lib;
let cfg = config.within.services.printerfacts;
in {
  options.within.services.printerfacts = {
    enable = mkEnableOption "Activates the printerfacts server";
    useACME = mkEnableOption "Enables ACME for cert stuff";

    domain = mkOption {
      type = types.str;
      default = "printerfacts.akua";
      example = "printerfacts.cetacean.club";
      description =
        "The domain name that nginx should check against for HTTP hostnames";
    };

    sockPath = mkOption rec {
      type = types.str;
      default = "/tmp/printerfacts.sock";
      example = default;
      description = "The unix domain socket that printerfacts should listen on";
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
        RestrictAddressFamilies = [ "~AF_NETLINK" ];
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
        UMask = "007";
      };

      script = let site = pkgs.tulpa.dev.cadey.printerfacts;
      in ''
        export SOCKPATH=${cfg.sockPath}
        export DOMAIN=${toString cfg.domain}
        export RUST_LOG=info
        cd ${site}
        exec ${site}/bin/printerfacts
      '';
    };

    services.cfdyndns = mkIf cfg.useACME { records = [ "${cfg.domain}" ]; };

    services.nginx.virtualHosts."${cfg.domain}" = {
      locations."/" = {
        proxyPass = "http://unix:${cfg.sockPath}";
        proxyWebsockets = true;
      };
      forceSSL = cfg.useACME;
      useACMEHost = "cetacean.club";
      extraConfig = ''
        access_log /var/log/nginx/printerfacts.access.log;
      '';
    };
  };
}
