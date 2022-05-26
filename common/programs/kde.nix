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
        okular
        plasma-browser-integration
        spectacle
      ];

    services.xserver.desktopManager.plasma5.enable = true;
    programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.libsForQt5.ksshaskpass.out}/bin/ksshaskpass";
  };
}
