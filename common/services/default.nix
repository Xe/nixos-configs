{ config, lib, pkgs, ... }:

{
  imports = [
    ./aerial.nix
    ./backup.nix
    ./goproxy.nix
    ./lewa.nix
    ./mi.nix
    ./oragono.nix
    ./printerfacts.nix
    ./tron.nix
    ./withinbot.nix
    ./xesite.nix
  ];
}
