{ config, pkgs, lib, ... }:

with lib;

let cfg = config.within.services.tulpanomicon;
in {
  options.within.services.tulpanomicon.enable =
    mkEnableOption "Activates tulpa --force";

  config = mkIf cfg.enable {
    services.nginx.virtualHosts."tulpanomicon" = {
      serverName = "tulpanomicon.guide";
      locations."/".root = "${pkgs.tulpa.dev.tulpa-ebooks.tulpanomicon}";
      forceSSL = true;
      useACMEHost = "tulpanomicon.guide";
    };

    services.cfdyndns.records = [ "tulpanomicon.guide" ];
  };
}
