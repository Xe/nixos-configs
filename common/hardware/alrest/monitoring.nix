{ config, pkgs, ... }:

let metadata = pkgs.callPackage ../../../ops/metadata/peers.nix { };
in {
  services.prometheus = {
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        listenAddress = metadata.raw."${config.networking.hostName}".tailscale;
      };
      wireguard = {
        enable = true;
        listenAddress = metadata.raw."${config.networking.hostName}".tailscale;
      };
    };
  };
}
