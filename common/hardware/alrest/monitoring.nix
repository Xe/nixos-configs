{ config, pkgs, ... }:

let metadata = pkgs.callPackage ../../../ops/metadata/peers.nix { };
in {
  services.prometheus = {
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
      };
      wireguard = {
        enable = true;
      };
    };
  };
}
