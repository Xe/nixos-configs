{ config, pkgs, ... }:

{
  networking.nameservers = [
    "10.77.0.1"
    "8.8.8.8"
    "1.1.1.1"
  ];

  environment.systemPackages = with pkgs; [
    wireguard
  ];
}
