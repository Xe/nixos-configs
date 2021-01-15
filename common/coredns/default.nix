{ lib, config, ... }:

with lib;

let cfg = config.within.coredns;
in {
  options.within.coredns = {
    enable =
      mkEnableOption "Enables coreDNS for ad-blocking DNS and DNS in general";
    addServer = mkEnableOption "Add this server to the nameserver list";
    addr = mkOption {
      type = types.str;
      default = "127.0.0.1";
      example = "10.77.2.8";
    };
    prometheus = {
      enable = mkEnableOption "Add prometheus monitoring";
      port = mkOption {
        type = types.port;
        default = 47824;
      };
    };
  };

  config = mkIf cfg.enable {
    services.coredns = {
      enable = true;

      config = let
        prom = if cfg.prometheus.enable then
          "prometheus ${cfg.addr}:${toString cfg.prometheus.port}"
        else
          "";
      in ''
        . {
          bind ${cfg.addr}
          ${prom}
          # Cloudflare and Google
          forward . 1.1.1.1 1.0.0.1 8.8.8.8 8.8.4.4
          cache
        }

        akua {
          bind ${cfg.addr}
          ${prom}
          file ${./akua.zone}
        }

        localhost {
          bind ${cfg.addr}
          ${prom}
          template IN A  {
              answer "{{ .Name }} 0 IN A 127.0.0.1"
          }
        }
      '';
    };

    networking = mkIf cfg.addServer { nameservers = [ cfg.addr ]; };
  };
}
