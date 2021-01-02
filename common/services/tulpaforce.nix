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
    };

    services.cfdyndns.records = [ "tulpaforce.xyz" ];
  };
}
