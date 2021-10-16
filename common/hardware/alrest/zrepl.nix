{ config, pkgs, lib, ... }:

{
  within.backups = {
    enable = true;
    paths =
      [ "/home/cadey/.ssh" "/home/cadey/code" "/srv" "/var/lib/tailscale" ];
    exclude = [
      "'**/target'"
      "'**/.cache'"
      "'**/.nix-profile'"
      "'**/.elm'"
      "'**/.emacs.d'"
    ];
  };
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
        type = "push";
        connect = {
          type = "tcp";
          address = "100.68.185.47:29491";
        };
        filesystems = { "rpool/safe<" = true; };
        send = {
          #encrypted = true;
          compressed = true;
          raw = true;
        };
        snapshotting = {
          type = "periodic";
          prefix = "zrepl_";
          interval = "60m";
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
              lib.concatStringsSep " | " [ "1x1h(keep=all)" "24x1h" "30x1d" ];
          }];
        };
      }];
    };
  };
}
