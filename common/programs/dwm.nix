{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.cadey.dwm;
in {
  options = { cadey.dwm.enable = mkEnableOption "dwm"; };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ dwm st ];
    programs.slock.enable = true;
    services.xserver.windowManager.session = singleton {
      name = "dwm";
      start = ''
        ${pkgs.dwm}/bin/dwm &
        waitPID=$!
      '';
    };
  };
}
