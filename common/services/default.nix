{ config, lib, pkgs, ... }:

{
  imports = [
    ./aerial.nix
    ./backup.nix
    ./goproxy.nix
    ./graphvizonline.nix
    ./hlang.nix
    ./lewa.nix
    ./idp.nix
    ./mi.nix
    ./oragono.nix
    ./printerfacts.nix
    ./tron.nix
    ./tulpaforce.nix
    ./tulpanomicon.nix
    ./withinbot.nix
    ./withinwebsite.nix
    ./xesite.nix
  ];
}
