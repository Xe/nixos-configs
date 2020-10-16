{ config, pkgs, ... }:

let
  wp = ./cadey_seaside_wp.png;

  picom = pkgs.picom.overrideAttrs (old: rec {
    version = "git";
    src = builtins.fetchurl "https://github.com/ibhagwan/picom/archive/next.tar.gz";
  });
in {
  home.packages = with pkgs; [ dmenu libnotify feh ];

  home.file = {
    ".dwm/autostart.sh" = {
      executable = true;
      text = ''
        #!/bin/sh

        ~/.fehbg || ${pkgs.feh}/bin/feh --bg-scale ${wp}
        ${picom}/bin/picom --vsync --dbus --config ${./picom.conf} --experimental-backends --backend glx -c &
        ${pkgs.pasystray}/bin/pasystray &
        ${pkgs.dunst}/bin/dunst &
        ${pkgs.xorg.xmodmap}/bin/xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'
        ${pkgs.nur.repos.xe.cabytcini}/bin/cabytcini &
      '';
    };

    ".config/dunst/dunstrc".source = ./dunstrc;
  };
}
