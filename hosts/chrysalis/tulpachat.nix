{ config, pkgs, ... }:

let
  mkUnit = { message, sched, ... }: {
    after = [ "tulpachat-webhook-key.service" ];
    wants = [ "tulpachat-webhook-key.service" ];
    serviceConfig.Type = "oneshot";
    script = ''
      MESSAGE='${message}'
      WEBHOOK="$(cat /run/keys/tulpachat-webhook)"
      USERNAME='Report Reminder'

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
    tulpachat-weekly-reminder = mkUnit {
      message = "Hey <@&628452770344599573> Time for a weekly progress report!";
      sched = "Sun *-*-* 16:00:00";
    };
    tulpachat-monthly-reminder = mkUnit {
      message =
        "Hey <@&671224325646450698> Time for a monthly progress report!";
      sched = "*-*-1 16:00:00";
    };
  };

  within.secrets.tulpachat-webhook = {
    source = ./secret/tulpachat-webhook;
    dest = "/run/keys/tulpachat-webhook";
    permissions = "0400";
  };
}
