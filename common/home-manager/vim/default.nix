{ lib, config, pkgs, ... }:

with lib;

let cfg = config.xe.vim;
in {
  options.xe.vim.enable = mkEnableOption "Enables Xe's vim config";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ vim ];

    home.file.".vimrc".source = ./vimrc;
  };
}
