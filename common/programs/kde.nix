{ config, pkgs, lib, ... }:

with lib;
let cfg = config.cadey.kde;
in {
  options = { cadey.kde.enable = mkEnableOption "KDE apps"; };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
        amarok
        ark
        kate
        latte-dock
        okular
        plasma-browser-integration
        spectacle
      ];
  };
}
