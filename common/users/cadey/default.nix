{ config, pkgs, ... }:

{
  imports = [ ./core.nix ];

  home.packages = with pkgs; [ vim ];
}
