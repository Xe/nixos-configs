{ config, pkgs, ... }:

{
  networking.nameservers = [
    "8.8.8.8"
    "1.1.1.1"
  ];

  services.resolved.fallbackDns = config.networking.nameservers;

  environment.systemPackages = with pkgs; [
    wireguard
  ];
}
