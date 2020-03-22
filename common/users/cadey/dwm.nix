{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ dmenu ];

  home.file = {
    ".dwm/autostart.sh" = {
      executable = true;
      text = ''
        #!/bin/sh

        ${pkgs.feh}/bin/feh --bg-scale ~/Pictures/Orca-HD-Wallpaper.jpg
        ${pkgs.compton}/bin/compton &
      '';
    };
  };
}
