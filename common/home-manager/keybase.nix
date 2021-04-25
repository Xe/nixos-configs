{ config, lib, pkgs, ... }:

with lib;

let cfg = config.xe.keybase;
in {
  options.xe.keybase = {
    enable = mkEnableOption "Enable keybase/kbfs support";
    gui = mkEnableOption "Enable keybase gui installation";
  };

  config = mkIf cfg.enable {
    services.keybase.enable = true;
    services.kbfs.enable = true;

    home.packages = if cfg.gui then [ pkgs.keybase-gui ] else [ pkgs.keybase ];
  };
}
