{ config, pkgs, nixosConfig, lib, ... }:

with lib;

let cfg = config.xe.weechat;
in {
  options.xe.weechat = {
    enable = mkEnableOption "Enables weechat-headless";
    hostname = mkOption {
      type = types.str;
      description = "hostname to enable this on";
      default = "chrysalis";
    };
  };

  config = mkIf cfg.enable (mkIf (nixosConfig.networking.hostName == cfg.hostname) {
    systemd.user.services.weechat = {
      Unit.Description = "weechat headless";
      Service.ExecStart = [ "${pkgs.weechat}/bin/weechat-headless --stdout" ];
      Install.WantedBy = [ "default.target" ];
    };
  });
}
