{ lib, config, pkgs, ... }:

with lib;

let cfg = config.xe.zathura;
in {
  options.xe.zathura.enable = mkEnableOption "Zathura PDF/ePub reader";
  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [ zathura ];

      file.".config/zathura/zathurarc".source = ./zathurarc;
    };
  };
}
