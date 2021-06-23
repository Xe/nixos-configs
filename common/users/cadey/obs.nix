{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ (wrapOBS { plugins = [ obs-studio-plugins.wlrobs ]; }) ];
}
