{ config, pkgs, ... }:

let
  nur-no-pkgs = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {};
in {
  imports = with nur-no-pkgs.repos.xe.modules; [
    ./dwm.nix
    ./keybase.nix
    ./media.nix
    ./obs.nix
    ./st
    ./xresources.nix

    luakit
    zathura
  ];
}
