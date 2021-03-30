{ config, pkgs, ... }:

let
  start = pkgs.stdenv.mkDerivation {
    pname = "start.akua";
    version = "latest";
    src = builtins.fetchurl {
      url =
        "https://raw.githubusercontent.com/Xe/xepkgs/a39de715fdd98639c40b874a4935f0a3e9a7e632/modules/luakit/start.html";
      sha256 = "04bsgcmnj50sh1a61r8bfqrysf34pdc0559hy5vvyljbbcvihkha";
    };
    phases = "installPhase";
    installPhase = ''
      mkdir -p $out
      cp $src $out/index.html
    '';
  };
in {
  services.nginx = {
    virtualHosts."start.akua" = {
      root = "${start}";
    };
  };
}
