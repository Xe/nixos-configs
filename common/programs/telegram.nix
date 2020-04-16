{ pkgs, config, lib, ... }:

with lib;
let cfg = config.cadey.telegram;
in {
  options = { cadey.telegram.enable = mkEnableOption "Telegram"; };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ tdesktop ];
  };
}
