{ config, pkgs, lib, ... }:

{
  services.zrepl = {
    enable = false;
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
        type = "push";
        connect = {
          type = "tcp";
          address = "[fda2:d982:1da2:180d:ce10:49d:742d:aab7]:29491";
        };
        filesystems = {
          "rpool/safe/vm<" = true;
          "rpool/safe/vm-images" = true;
          "rpool/safe/srv<" = true;
          "rpool/mkvm-test/buddy" = true;
          "rpool/safe/home" = true;
          "rpool/safe/root" = true;
        };
        send.compressed = true;
        snapshotting = {
          type = "periodic";
          prefix = "zrepl_";
          interval = "10m";
        };
        pruning = {
          keep_sender = [
            { type = "not_replicated"; }
            {
              type = "last_n";
              count = 10;
            }
          ];
          keep_receiver = [{
            type = "grid";
            regex = "^zrepl_";
            grid =
              lib.concatStringsSep " | " [ "1x1h(keep=all)" "24x1h" "365x1d" ];
          }];
        };
      }];
    };
  };
}
