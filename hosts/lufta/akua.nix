{ pkgs, config, ... }:

let metadata = pkgs.callPackage ../../ops/metadata/peers.nix { };
in {
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };
}
