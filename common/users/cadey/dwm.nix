{ config, pkgs, ... }:

let
  wp = ./cadey_seaside_wp.png;
in {
  home.packages = with pkgs; [ dmenu libnotify ];

  home.file = {
    ".dwm/autostart.sh" = {
      executable = true;
      text = ''
        #!/bin/sh

        ${pkgs.feh}/bin/feh --bg-scale ${wp}
        ${pkgs.picom}/bin/picom --vsync --use-damage --dbus --config ${./picom.conf} --experimental-backends --backend glx -c &
        ${pkgs.pasystray}/bin/pasystray &
        ${pkgs.dunst}/bin/dunst &
        ${pkgs.xorg.xmodmap}/bin/xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'
        ${pkgs.nur.repos.xe.cabytcini}/bin/cabytcini &
      '';
    };

    ".config/dunst/dunstrc".source = ./dunstrc;
  };
}
