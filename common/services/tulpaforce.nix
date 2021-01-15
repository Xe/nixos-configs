{ config, pkgs, lib, ... }:

with lib;

let cfg = config.within.services.tulpaforce;
in {
  options.within.services.tulpaforce.enable =
    mkEnableOption "Activates tulpa --force";

  config = mkIf cfg.enable {
    services.nginx.virtualHosts."tulpaforce.xyz" = {
      locations."/".root = "${pkgs.tulpa.dev.cadey.tulpaforce}";
      forceSSL = true;
      useACMEHost = "tulpanomicon.guide";
      extraConfig = ''
        access_log /var/log/nginx/tulpaforce.access.log;
      '';
    };

    services.cfdyndns.records = [ "tulpaforce.xyz" ];
  };
}
