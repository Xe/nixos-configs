{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.cadey.dwm;
in {
  options = { cadey.dwm.enable = mkEnableOption "dwm"; };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs.nur.repos.xe; [ dwm st ];
    programs.slock.enable = true;
    services.xserver.windowManager.session = singleton {
      name = "dwm";
      start = ''
        ${pkgs.nur.repos.xe.dwm}/bin/dwm &
        waitPID=$!
      '';
    };
  };
}
