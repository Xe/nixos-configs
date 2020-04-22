{ config, pkgs, ... }:

let
  start = pkgs.stdenv.mkDerivation {
    pname = "start.akua";
    version = "latest";
    src = builtins.fetchurl {
      url =
        "https://raw.githubusercontent.com/Xe/xepkgs/master/modules/luakit/start.html";
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
    sha256 = "06c85sb23qsa7am0qiib5jff7l1fncbd7mjn981w07m04zdv2iil";
  };
  key = builtins.fetchurl {
    url = "https://certs.akua/start.akua/key.pem";
    sha256 = "1akv91cgb1mkja4n53imz8b7fdrwy8ajhsxavwmijdambkrrj3by";
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
