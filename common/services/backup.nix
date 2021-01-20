{ config, lib, pkgs, ... }:

let cfg = config.within.backups;
in with lib; {
  options.within.backups = {
    enable = mkEnableOption "Enables per-host backups to rsync.net";
    paths = mkOption {
      type = with types; listOf str;
      default = [ "/home" "/srv" "/var/lib" "/root" ];
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
        passCommand = "cat /root/borgbackup_passphrase";
      };
      environment.BORG_RSH = "ssh -i /root/borgbackup_ssh_key";
      compression = "auto,lzma";
      startAt = "daily";
    };

    within.secrets.borgbackup_passphrase = {
      source = ./secrets/borg_passphrase;
      dest = "/root/borgbackup_passphrase";
    };
    within.secrets.borgbackup_ssh_key = {
      source = ./secrets/borg_ssh_key;
      dest = "/root/borgbackup_ssh_key";
    };
  };
}
