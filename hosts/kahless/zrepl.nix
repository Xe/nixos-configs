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
        name = "lufta_backups";
        type = "sink";
        serve = {
          type = "tcp";
          listen = "[fda2:d982:1da2:180d:ce10:49d:742d:aab7]:29491";
          clients = {
            "fda2:d982:1da2:180d:b7a4:9c5c:989b:ba02" = "lufta";
            "fda2:d982:1da2:a88b:6c8:3903:be65:3261" = "genza";
          };
        };
        root_fs = "rpool/backup";
      }];
    };
  };
}
