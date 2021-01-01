{ config, lib, pkgs, ... }:

{
  imports = [
    ./aerial.nix
    ./backup.nix
    ./mi.nix
    ./tron.nix
    ./withinbot.nix
    ./xesite.nix
  ];
}
