{ config, pkgs, ... }:

let
  mkUnit = { message, ... }: {
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
  };

  mkTimer = { sched, name, ... }: {
    wantedBy = [ "timers.target" ];
    partOf = [ "tulpachat-${name}-reminder.service" ];
    timerConfig.OnCalendar = "${sched}";
  };
in {
  systemd = {
    services = {
      tulpachat-weekly-reminder = mkUnit {
        message = "Hey <@&628452770344599573> Time for a weekly progress report!";
      };
      tulpachat-monthly-reminder = mkUnit {
        message = "Hey <@&671224325646450698> Time for a monthly progress report!";
      };
    };
    timers = {
      # DayOfWeek Year-Month-Day Hour:Minute:Second
      tulpachat-weekly-reminder = mkTimer {
        sched = "Sun *-*-* 16:00:00";
        name = "weekly";
      };
      tulpachat-monthly-reminder = mkTimer {
        sched = "*-*-1 16:00:00";
        name = "monthly";
      };
    };
  };

  deployment.keys.tulpachat-webhook.text =
    builtins.readFile ./secret/tulpachat-webhook;
}
