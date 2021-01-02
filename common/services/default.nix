{ config, lib, pkgs, ... }:

{
  imports = [
    ./aerial.nix
    ./backup.nix
    ./goproxy.nix
    ./hlang.nix
    ./lewa.nix
    ./mi.nix
    ./oragono.nix
    ./printerfacts.nix
    ./tron.nix
    ./tulpaforce.nix
    ./tulpanomicon.nix
    ./withinbot.nix
    ./xesite.nix
  ];
}
