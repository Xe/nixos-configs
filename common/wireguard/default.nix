{ config, pkgs, ... }:

{
  imports = [ ./dnsd.nix ];

  networking.nameservers = [
    "127.0.0.1"
    "10.77.0.1"
    "8.8.8.8"
    "1.1.1.1"
  ];
}
