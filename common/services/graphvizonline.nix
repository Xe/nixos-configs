{ config, pkgs, lib, ... }:

with lib;

let cfg = config.within.services.graphviz;
in {
  options.within.services.graphviz.enable =
    mkEnableOption "Activates the graphviz site";

  config = mkIf cfg.enable {
    services.nginx.virtualHosts."graphviz" = {
      serverName = "graphviz.christine.website";
      locations."/".root = "${pkgs.github.com.Xe.GraphvizOnline}";
      forceSSL = true;
      useACMEHost = "christine.website";
    };

    services.cfdyndns.records = [ "graphviz.christine.website" ];
  };
}
