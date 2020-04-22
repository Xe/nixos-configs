{ config, pkgs, ... }:

let
  start = pkgs.stdenv.mkDerivation {
    pname = "start.akua";
    version = "latest";
    src = builtins.fetchurl
      "https://raw.githubusercontent.com/Xe/xepkgs/master/modules/luakit/start.html";
    phases = "installPhase";
    installPhase = ''
      mkdir -p $out
      cp $src $out/index.html
    '';
  };

in {
  services.nginx = {
    enable = true;

    virtualHosts."start.akua" = {
      forceSSL = true;
      root = "${start}";
      sslCertificate =
        "${builtins.fetchurl "https://certs.akua/start.akua/cert.pem"}";
      sslCertificateKey =
        "${builtins.fetchurl "https://certs.akua/start.akua/key.pem"}";
    };
  };
}
