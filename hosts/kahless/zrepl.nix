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
            "fda2:d982:1da2:ed22:33c2:b50a:e0bd:964d" = "kos-mos";
            "fd7a:115c:a1e0:ab12:4843:cd96:6248:3209" = "kos-mos";
            "fda2:d982:1da2:ed22:0a60:029e:327d:df92" = "logos";
            "fd7a:115c:a1e0:ab12:4843:cd96:626a:453a" = "logos";
            "fda2:d982:1da2:ed22:d052:8b54:cc73:c673" = "ontos";
            "fd7a:115c:a1e0:ab12:4843:cd96:6242:e26d" = "ontos";
            "fda2:d982:1da2:ed22:eba3:7f7d:281a:a132" = "pneuma";
            "fd7a:115c:a1e0:ab12:4843:cd96:6278:eb76" = "pneuma";
          };
        };
        root_fs = "rpool/backup";
      }];
    };
  };
}
