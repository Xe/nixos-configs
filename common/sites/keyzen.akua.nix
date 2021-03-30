{ config, pkgs, ... }:

let
  keyzen = pkgs.stdenv.mkDerivation {
    pname = "keyzen";
    version = "latest";
    src = pkgs.fetchFromGitHub {
      owner = "first20hours";
      repo = "keyzen-colemak";
      rev = "360c1d06a05a732cae4ab00dba1733efcf350430";
      sha256 = "08sx8zdf7lxc11bka6wf1sjgd46siljfpgylwrw4198n1w81k8q4";
    };
    phases = "installPhase";
    installPhase = ''
      mkdir -p $out
      cp -vrf $src/public/* $out
    '';
  };
in {
  services.nginx.virtualHosts."keyzen.akua" = {
    root = "${keyzen}";
  };
}
