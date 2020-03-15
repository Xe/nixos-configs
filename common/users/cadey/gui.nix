{ config, pkgs, ... }:

{
  imports = [
    ./keybase.nix
    ./media.nix
    ./obs.nix
    ./urxvt.nix
    ./xresources.nix
    ./st
  ];
}
