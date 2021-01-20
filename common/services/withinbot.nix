{ config, lib, pkgs, ... }:
with lib; {
  options.within.services.withinbot.enable =
    mkEnableOption "Activates Withinbot (the furryhole chatbot)";

  config = mkIf config.within.services.withinbot.enable {
    users.users.withinbot = {
      createHome = true;
      description = "github.com/Xe/withinbot";
      isSystemUser = true;
      group = "within";
      home = "/srv/within/withinbot";
      extraGroups = [ "keys" ];
    };

    within.secrets = [{
      name = "withinbot";
      source = ./secrets/withinbot.env;
      dest = "/srv/within/withinbot/.env";
      owner = "withinbot";
      group = "within";
      permissions = "0400";
    }];

    systemd.services.withinbot = {
      wantedBy = [ "multi-user.target" ];
      after = [ "withinbot-key.service" ];
      wants = [ "withinbot-key.service" ];

      serviceConfig = {
        User = "withinbot";
        Group = "within";
        Restart = "on-failure";
        WorkingDirectory = "/srv/within/withinbot";
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

      script = let withinbot = pkgs.within.withinbot;
      in ''
        export CAMPAIGN_FOLDER=${withinbot}/campaigns
        export RUST_LOG=error,serenity::client::bridge::gateway::shard_runner=error,serenity::gateway::shard=error
        exec ${withinbot}/bin/withinbot
      '';
    };
  };
}
