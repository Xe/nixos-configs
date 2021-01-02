{ config, pkgs, ... }:
let
  xepkgs = import (pkgs.fetchgit {
    url = "https://tulpa.dev/Xe/nixpkgs";
    rev = "5621d41482bca79d05c97758bb86eeb9099e26c9";
    sha256 = "1hbq5laly1946wjqn9rh83lhcw720wxsv3d5f89f15gyijd9i9x8";
  }) { };
  dnsd = xepkgs.dnsd;
in {
  systemd.services.dnsd = {
    enable = true;
    description = "DNS Daemon";
    script = "${dnsd}/bin/dnsd";
    wantedBy = [ "multi-user.target" ];
  };
}
