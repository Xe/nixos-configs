{ config, pkgs, ... }:

let
  mkUnit = { message, sched, ... }: {
    after = [ "tulpachat-mods-webhook-key.service" ];
    wants = [ "tulpachat-mods-webhook-key.service" ];
    serviceConfig.Type = "oneshot";
    script = ''
      MESSAGE='${message}'
      WEBHOOK="$(cat /run/keys/tulpachat-mods-webhook)"
      USERNAME='What is Found Here'

      ${pkgs.curl}/bin/curl \
          -X POST \
          -F "content=$MESSAGE" \
          -F "username=$USERNAME" \
          "$WEBHOOK"
    '';
    startAt = sched;
  };

in {
  systemd.services = {
    tulpachat-mods-weekly-reminder = mkUnit {
      message = "It is time for a weekly discussion!";
      sched = "Sun *-*-* 16:00:00";
    };
  };

  within.secrets.tulpachat-mods-webhook = {
    source = ./secret/tulpachat-mods-webhook;
    dest = "/run/keys/tulpachat-mods-webhook";
    permissions = "0400";
  };
}
