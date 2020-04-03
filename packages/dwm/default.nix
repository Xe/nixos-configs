{ config, pkgs, lib, ... }:

with lib;
let
  dwm = pkgs.dwm.overrideAttrs (old: rec {
    postPatch = ''
      cp ${./config.h} ./config.h
    '';

    patches = [
      ./alphasystray.diff
      ./dwm-centeredwindowname-20180909-6.2.diff
      ./dwm-uselessgap-6.2.diff
      ./dwm-autostart-20161205-bb3bd6f.diff
    ];
  });
  cfg = config.cadey.dwm;
in {
  options = {
    cadey.dwm.enable = mkEnableOption "dwm";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ dwm ];

    services.xserver.windowManager.session = singleton {
      name = "dwm";
      start = ''
        ${dwm}/bin/dwm &
        waitPID=$!
      '';
    };
  };
}
