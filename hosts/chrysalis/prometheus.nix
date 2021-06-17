{ ... }:

{
  services.prometheus = {
    enable = true;
    globalConfig.scrape_interval = "15s";
    scrapeConfigs = [
      # services
      {
        job_name = "mi";
        static_configs = [{ targets = [ "10.77.3.1:38184" ]; }];
      }
      {
        job_name = "site";
        metrics_path = "/xesite";
        static_configs = [{ targets = [ "lufta.akua.xeserv.us:43705" ]; }];
      }
      {
        job_name = "ircmon";
        metrics_path = "/ircmon";
        static_configs = [{ targets = [ "lufta.akua.xeserv.us:43705" ]; }];
      }
      {
        job_name = "corerad";
        static_configs = [{ targets = [ "10.77.2.1:38177" ]; }];
      }
      {
        job_name = "coredns";
        static_configs = [{ targets = [ "10.77.2.2:47824" ]; }];
      }
      {
        job_name = "nginx";
        static_configs = [{
          targets = [ "10.77.3.1:9113" "10.77.3.1:9117" ];
          labels.host = "lufta";
        }];
      }
      {
        job_name = "rhea";
        static_configs = [{ targets = [ "lufta.akua.xeserv.us:23818" ]; }];
      }

      # computers
      {
        job_name = "chrysalis";
        static_configs = [{ targets = [ "10.77.2.2:9100" "10.77.2.2:9586" ]; }];
      }
      {
        job_name = "shachi";
        static_configs = [{ targets = [ "10.77.2.8:9100" "10.77.2.8:9586" ]; }];
      }
      {
        job_name = "lufta";
        static_configs = [{ targets = [ "10.77.3.1:9100" "10.77.3.1:9586" ]; }];
      }
      {
        job_name = "kos-mos";
        static_configs = [{ targets = [ "100.72.50.9:9100" "100.72.50.9:9586" ]; }];
      }
      {
        job_name = "logos";
        static_configs = [{ targets = [ "100.106.69.58:9100" "100.106.69.58:9586" ]; }];
      }
      {
        job_name = "ontos";
        static_configs = [{ targets = [ "100.66.226.109:9100" "100.66.226.109:9586" ]; }];
      }
      {
        job_name = "pneuma";
        static_configs = [{ targets = [ "100.120.235.118:9100" "100.120.235.118:9586" ]; }];
      }
    ];

    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
      };
      wireguard.enable = true;
    };
  };
}
