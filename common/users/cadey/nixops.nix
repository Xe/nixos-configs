{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ nixops ];
}
