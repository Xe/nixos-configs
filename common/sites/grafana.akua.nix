{ config, pkgs, ... }:

let
  cert = builtins.fetchurl {
    url = "https://certs.akua/grafana.akua/cert.pem";
    sha256 = "0xy27ry6bh1hq63ji4ipj22wl4nf7kg3q9x78r3kz1ppf627rv7j";
  };
  key = builtins.fetchurl {
    url = "https://certs.akua/grafana.akua/key.pem";
    sha256 = "0hk6dpkxmgxfzshc8vm1lb0paqvmkaf435gmg4j2q5xaz86ihx6h";
  };
in {
  services.nginx.virtualHosts."grafana.akua" = {
    forceSSL = true;
    sslCertificate = "${cert}";
    sslCertificateKey = "${key}";
    locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.grafana.port}";
        proxyWebsockets = true;
    };
  };
}
