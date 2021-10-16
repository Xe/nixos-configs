{ config, pkgs, lib, ... }:

{
  services.zrepl = {
    enable = true;
    settings = {
      global = {
        logging = [{
          type = "syslog";
          level = "info";
          format = "human";
        }];
      };

      jobs = [{
        name = "backups";
        type = "sink";
        serve = {
          type = "tcp";
          listen = "100.68.185.47:29491";
          clients = {
            "100.103.44.76" = "lufta";
            "fda2:d982:1da2:a88b:6c8:3903:be65:3261" = "genza";
            "100.122.181.67" = "kos-mos";
            "100.126.232.35" = "logos";
            "100.103.116.84" = "ontos";
            "100.78.40.86" = "pneuma";
          };
        };
        root_fs = "rpool/backup";
      }];
    };
  };
}
