{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ obs-studio obs-wlrobs ];
}
