{ config, pkgs, lib, ... }:

with lib;

let cfg = config.within.services.lewa;
in {
  options.within.services.lewa = {
    enable = mkEnableOption "Activates the eBook for l'ewa";
    useACME = mkEnableOption "enables ACME for cert stuff";

    domain = mkOption {
      type = types.str;
      default = "lewa.akua";
      example = "lewa.cetacean.club";
      description =
        "The domain name that nginx should check against for HTTP hostnames";
    };
  };

  config = mkIf cfg.enable {
    services.nginx.virtualHosts."lewa" = {
      serverName = "${cfg.domain}";
      locations."/".root = "${pkgs.tulpa.dev.cadey.lewa}/book";
      forceSSL = cfg.useACME;
      useACMEHost = "within.website";
      extraConfig = ''
        access_log /var/log/nginx/lewa.access.log;
      '';
    };

    services.cfdyndns = mkIf cfg.useACME { records = [ "${cfg.domain}" ]; };
  };
}
