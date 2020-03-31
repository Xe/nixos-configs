{ config, pkgs, ... }:

let
  wp = ./cadey_pool_wp.png;
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

  services.dwm-status = {
    enable = true;
    order = [ "audio" "cpu_load" "time" ];
  };
}
