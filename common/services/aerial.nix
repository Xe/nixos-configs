{ config, lib, pkgs, ... }:
with lib; {
  options.within.services.aerial.enable =
    mkEnableOption "Activates Aerial (the PonyvilleFM chatbot)";

  config = mkIf config.within.services.aerial.enable {
    users.users.aerial = {
      createHome = true;
      description = "github.com/PonyvilleFM/aura";
      isSystemUser = true;
      group = "within";
      home = "/srv/within/aerial";
      extraGroups = [ "keys" ];
    };

    deployment.keys.aerial = {
      text = builtins.readFile ./secrets/aerial.env;
      user = "aerial";
      group = "within";
      permissions = "0640";
    };

    systemd.services.aerial = {
      wantedBy = [ "multi-user.target" ];
      after = [ "aerial-key.service" ];
      wants = [ "aerial-key.service" ];

      serviceConfig = {
        User = "aerial";
        Group = "within";
        Restart = "on-failure";
        WorkingDirectory = "/srv/within/aerial";
        RestartSec = "30s";

        # security settings
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

      script = let aura = pkgs.within.aura;
      in ''
        export $(grep -v '^#' /run/keys/aerial | xargs)
        exec ${aura}/bin/aerial
      '';
    };
  };
}
