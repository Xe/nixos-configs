{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ obs-linuxbrowser obs-studio obs-wlrobs ];
}
