{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ capture vlc transmission ];
}
