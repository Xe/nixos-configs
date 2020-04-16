{ pkgs, config, lib, ... }:

with lib;
let cfg = config.cadey.discord;
in {
  options = { cadey.discord.enable = mkEnableOption "Discord messenger"; };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs.nur.repos.xe.discord; [ ptb stable ];
  };
}
