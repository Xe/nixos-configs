{ config, pkgs, ... }:

let
  mkUnit = { message, sched, ... }: {
    after = [ "furryhole-webhook-key.service" ];
    wants = [ "furryhole-webhook-key.service" ];
    serviceConfig.Type = "oneshot";
    script = ''
      MESSAGE='${message}'
      WEBHOOK="$(cat /run/keys/furryhole-webhook)"
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
    furryhole-owo-cheating = mkUnit {
      message = "owo";
      sched = "*-01-01 00:00:00";
    };
  };

  within.secrets.furryhole-webhook = {
    source = ./secret/furryhole-webhook;
    dest = "/run/keys/furryhole-webhook";
    permissions = "0400";
  };
}
