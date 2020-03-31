{ config, pkgs, ... }:

let
  wp = ./cadey_seaside_wp.png;
in {
  home.packages = with pkgs; [ dmenu ];

  home.file = {
    ".dwm/autostart.sh" = {
      executable = true;
      text = ''
        #!/bin/sh

        ${pkgs.feh}/bin/feh --bg-scale ${wp}
        ${pkgs.compton}/bin/picom &
      '';
    };
  };
}
