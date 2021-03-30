{ config, pkgs, ... }:

{
  networking.nameservers = [
    "100.100.100.100"
    "8.8.8.8"
    "1.1.1.1"
  ];
  networking.search = [ "christine.website.beta.tailscale.net" "akua.xeserv.us" ];

  networking.firewall.trustedInterfaces = [ "akua" ];

  services.resolved.fallbackDns = config.networking.nameservers;

  environment.systemPackages = with pkgs; [ wireguard ];
}
