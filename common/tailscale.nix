{ pkgs, lib, config, ... }:

let cfg = config.cadey.tailscale;
in with lib; {
  options.cadey.tailscale = {
    enable = mkEnableOption "Enables Tailscale";

    port = mkOption {
      type = types.port;
      default = 41641;
      description = "The port to listen on for tunnel traffic (0=autoselect).";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.tailscale;
      defaultText = "pkgs.tailscale";
      description = "The package to use for tailscale";
    };

    notifySupport = mkEnableOption "Enables systemd-notify support";

    autoprovision = {
      enable = mkEnableOption "Automatically provision this with an API key?";

      key = mkOption {
        type = types.str;
        description = "The API secret used to provision Tailscale access";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ tailscale ];

    systemd.packages = [ cfg.package ];
    systemd.services.tailscale = {
      description = "Tailscale client daemon";

      after = [ "network-pre.target" ];
      wants = [ "network-pre.target" ];
      wantedBy = [ "multi-user.target" ];

      unitConfig = {
        StartLimitIntervalSec = 0;
        StartLimitBurst = 0;
      };

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/tailscaled --port ${toString cfg.port}";

        RuntimeDirectory = "tailscale";
        RuntimeDirectoryMode = 755;

        StateDirectory = "tailscale";
        StateDirectoryMode = 750;

        CacheDirectory = "tailscale";
        CacheDirectoryMode = 750;

        Restart = "on-failure";
      } // (mkIf cfg.notifySupport {
        ExecStart = "${cfg.package}/bin/tailscaled --port ${toString cfg.port}";

        RuntimeDirectory = "tailscale";
        RuntimeDirectoryMode = 755;

        StateDirectory = "tailscale";
        StateDirectoryMode = 750;

        CacheDirectory = "tailscale";
        CacheDirectoryMode = 750;

        Restart = "on-failure";
        Type = "notify";
      });
    };

    systemd.services.tailscale-autoprovision = mkIf cfg.autoprovision.enable {
      description = "Tailscale autoprovision hack";

      after = [ "network-pre.target" "tailscale.service" ];
      wants = [ "network-pre.target" "tailscale.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "oneshot";
        RuntimeDirectory = "tailscale";
        RuntimeDirectoryMode = 755;

        StateDirectory = "tailscale";
        StateDirectoryMode = 750;

        CacheDirectory = "tailscale";
        CacheDirectoryMode = 750;
      };

      script = ''
        ${cfg.package}/bin/tailscale up --authkey=${cfg.autoprovision.key}
      '';
    };
  };
}
