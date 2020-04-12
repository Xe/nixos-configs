{ config, pkgs, ... }:

let
  wp = ./cadey_seaside_wp.png;
  nur = import <nur> { inherit pkgs; };
in {
  home.packages = with pkgs; [ dmenu ];

  home.file = {
    ".dwm/autostart.sh" = {
      executable = true;
      text = ''
        #!/bin/sh

        ${pkgs.feh}/bin/feh --bg-scale ${wp}
        ${pkgs.picom}/bin/picom --vsync --use-damage &
        ${pkgs.pasystray}/bin/pasystray &
        ${pkgs.dunst}/bin/dunst &
        ${pkgs.xorg.xmodmap}/bin/xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'
        ${nur.repos.xe.cabytcini}/bin/cabytcini &
      '';
    };

    ".config/dunst/dunstrc".source = ./dunstrc;
  };
}
