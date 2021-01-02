{ config, lib, pkgs, ... }:

let cfg = config.within.backups;
in with lib; {
  options.within.backups = {
    enable = mkEnableOption "Enables per-host backups to rsync.net";
    paths = mkOption {
      type = with types; listOf str;
      default = [ "/home" "/srv" "/var/lib" ];
      description = "paths to backup to rsync.net";
    };
    exclude = mkOption {
      type = with types; listOf str;
      default = [
        "/var/lib/docker"
        "/var/lib/systemd"
        "/var/lib/libvirt"
        "'**/.cache'"
        "'**/.nix-profile'"
        "'**/.elm'"
        "'**/.emacs.d'"
      ];
      description = "paths to NOT backup to rsync.net";
    };
    repo = mkOption {
      type = types.str;
      description = "Repo to submit backups to";
    };
  };

  config = mkIf config.within.backups.enable {
    services.borgbackup.jobs."borgbase" = {
      paths = cfg.paths;
      exclude = cfg.exclude;
      repo = cfg.repo;
      encryption = {
        mode = "repokey-blake2";
        passCommand = "cat /run/keys/borgbackup_passphrase";
      };
      environment.BORG_RSH = "ssh -i /run/keys/borgbackup_ssh_key";
      compression = "auto,lzma";
      startAt = "daily";
    };

    deployment.keys.borgbackup_passphrase.text =
      builtins.readFile ./secrets/borg_passphrase;
    deployment.keys.borgbackup_ssh_key.text =
      builtins.readFile ./secrets/borg_ssh_key;
  };
}
