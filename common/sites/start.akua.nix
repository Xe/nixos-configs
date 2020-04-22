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
  cert = builtins.fetchurl {
    url = "https://certs.akua/start.akua/cert.pem";
    sha256 = "16d823kcn76wg9p78y80grmk5pz56nmfxhl68jg5lyz82h2j4nxj";
  };
  key = builtins.fetchurl {
    url = "https://certs.akua/start.akua/key.pem";
    sha256 = "1r5v5sw721x719vc27h7194hjy512vhljc28lpipzkanbqf0sa72";
  };

in {
  services.nginx = {
    enable = true;

    virtualHosts."start.akua" = {
      forceSSL = true;
      root = "${start}";
      sslCertificate = "${cert}";
      sslCertificateKey = "${key}";
    };
  };
}
