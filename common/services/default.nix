{ config, lib, pkgs, ... }:

{
  imports = [
    ./aerial.nix
    ./backup.nix
    ./lewa.nix
    ./mi.nix
    ./printerfacts.nix
    ./tron.nix
    ./withinbot.nix
    ./xesite.nix
  ];
}
