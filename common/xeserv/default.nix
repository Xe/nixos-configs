{ config, pkgs, ... }:

{
  security.pki.certificateFiles = [
    "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
    ./xeserv_ca.pem
    ./xeserv_minica.pem
  ];
}
