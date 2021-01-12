{ lib, config, ... }:

with lib;

let
  cfg = config.within.coredns;
  v4net = "10.255.255";
  v6net = "fd11:7799:7248:1508";

in {
  options.within.coredns.enable =
    mkEnableOption "Enables coreDNS for ad-blocking DNS and DNS in general";

  config = mkIf cfg.enable {
    containers."coredns" = rec {
      hostAddress = "${v4net}.1";
      localAddress = "${v4net}.53";
      hostAddress6 = "${v6net}::";
      localAddress6 = "${v6net}::53";
      privateNetwork = true;

      autoStart = true;

      config = { ... }: {
        networking.firewall.enable = false;
        services.coredns = {
          enable = true;

          config = ''
            . {
              bind ${localAddress} #${localAddress6}
              # Cloudflare and Google
              forward . 100.100.100.100 1.1.1.1 1.0.0.1 8.8.8.8 8.8.4.4
              cache
            }

            akua {
              bind ${localAddress} #${localAddress6}
              file ${./akua.zone}
            }

            local {
              bind ${localAddress} #${localAddress6}
              template IN A  {
                  answer "{{ .Name }} 0 IN A 127.0.0.1"
              }
            }
          '';
        };
      };
    };

    networking.nameservers = [
      "${v4net}.53"
      #"${v6net}::53"
    ];
  };
}
