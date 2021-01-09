{ lib, config, ... }:

with lib;

let cfg = config.within.coredns;

in {
  options.within.coredns.enable =
    mkEnableOption "Enables coreDNS for ad-blocking DNS and DNS in general";

  config = mkIf cfg.enable {
    services.coredns = {
      enable = true;

      config = ''
        . {
          bind 127.0.0.1
          # Cloudflare and Google
          forward . 100.100.100.100 1.1.1.1 1.0.0.1 8.8.8.8 8.8.4.4
          cache
        }

        akua {
          bind 127.0.0.1
          file ${./akua.zone}
        }

        local {
          bind 127.0.0.1
          template IN A  {
              answer "{{ .Name }} 0 IN A 127.0.0.1"
          }
        }
      '';
    };
  };
}
