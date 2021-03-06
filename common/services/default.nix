{ config, lib, pkgs, ... }:

{
  imports = [
    ./aegis.nix
    ./aerial.nix
    ./aura.nix
    ./backup.nix
    ./goproxy.nix
    ./graphvizonline.nix
    ./hlang.nix
    ./johaus.nix
    ./lewa.nix
    ./idp.nix
    ./ircmon.nix
    ./mi.nix
    ./oragono.nix
    ./printerfacts.nix
    ./snoo2nebby.nix
    ./todayinmarch2020.nix
    ./tron.nix
    ./tulpaforce.nix
    ./tulpanomicon.nix
    ./withinbot.nix
    ./withinwebsite.nix
    ./xesite.nix
  ];
}
