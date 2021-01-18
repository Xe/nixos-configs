{ pkgs, config, ... }:

let metadata = pkgs.callPackage ../../ops/metadata/peers.nix { };
in {
  networking.wireguard.interfaces.akua =
    metadata.hosts."${config.networking.hostName}";

  within.coredns = {
    enable = true;
    addr = "10.77.3.1";
    addServer = true;
    prometheus.enable = true;
  };

  boot.kernel.sysctl = {
    "net.ipv4.forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };
}
