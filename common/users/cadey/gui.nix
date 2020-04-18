{ config, pkgs, ... }:

{
  imports = [
    ./dwm.nix
    ./keybase.nix
    ./media.nix
    ./obs.nix
    ./st
    ./xresources.nix
    ./zathura
  ];
}
