{ config, pkgs, ... }:

{
  networking.nameservers = [ "2001:4860:4860::8888" "2606:4700:4700::64" "8.8.8.8" "1.1.1.1" ];

  networking.firewall.trustedInterfaces = [ "akua" ];

  services.resolved.fallbackDns = config.networking.nameservers;

  environment.systemPackages = with pkgs; [ wireguard ];
}
