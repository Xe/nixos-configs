{ pkgs, ... }:

{
  home.file = {
    "bin/front" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash
        set -e

        who=$(cat ${./system.txt} | ${pkgs.dmenu}/bin/dmenu -p "front: " -m 0 -fn Hack:size=10 -nb '#1d2021' -nf '#ebdbb2' -sb '#b16286' -sf '#fbf1c7')
        ${pkgs.curl}/bin/curl --data $who https://home.cetacean.club/front
        ${pkgs.libnotify}/bin/notify-send 'Front change recorded' "$who is now front"
      '';
    };
  };
}
