{ config, pkgs, ... }:

let
  dwm = pkgs.dwm.overrideAttrs(old: rec {
    postPatch = ''
      cp ${./config.h} ./config.h
    '';

    patches = [
      ./alphasystray.diff
      ./dwm-centeredwindowname-20180909-6.2.diff
      ./dwm-uselessgap-6.2.diff
      ./dwm-autostart-20161205-bb3bd6f.diff
    ];
  }); in {
    home.packages = with pkgs; [ dwm dmenu ];

    home.file = {
      ".dwm/autostart.sh" = {
        executable = true;
        text = ''
          #!/bin/sh

          ${pkgs.feh}/bin/feh --bg-scale ~/Pictures/Orca-HD-Wallpaper.jpg
        '';
      };
    };
  }
