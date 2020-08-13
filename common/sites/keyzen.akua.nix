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

  cert = builtins.fetchurl {
    url = "https://certs.akua/keyzen.akua/cert.pem";
    sha256 = "0r7d7ww1saiq9jdm9sgfb6cjz726wca0ikmxgpph5sys02x9pd85";
  };
  key = builtins.fetchurl {
    url = "https://certs.akua/keyzen.akua/key.pem";
    sha256 = "11jh2f0yvmdycda5lw4qdykdnapcn7a8yndn0712qzdn0ihimim5";
  };
in {
  services.nginx.virtualHosts."keyzen.akua" = {
    forceSSL = true;
    root = "${keyzen}";
    sslCertificate = "${cert}";
    sslCertificateKey = "${key}";
  };
}
