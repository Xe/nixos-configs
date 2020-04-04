{ config, pkgs, lib, ... }:

with lib;
let
  nur = import (builtins.fetchTarball
    "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  dwm = nur.repos.xe.dwm;
  cfg = config.cadey.dwm;
in {
  options = { cadey.dwm.enable = mkEnableOption "dwm"; };

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
