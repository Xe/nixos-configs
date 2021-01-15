{ config, pkgs, ... }:

{
  virtualisation.oci-containers.containers = {
    maison = {
      image = "xena/maison:95208b77c273ebbf74198865713bcbace4b081de";
      ports = [ "127.0.0.1:38182:5000" ];
      environment = import ./secret/maison.nix;
    };

    olin = {
      image = "xena/olin:latest";
      ports = [ "127.0.0.1:25723:5000" ];
      environment.PORT = "5000";
    };
  };

  services.cfdyndns.records = [ "maison.within.website" "olin.within.website" ];

  services.nginx.virtualHosts."maison.within.website" = {
    locations."/".proxyPass = "http://127.0.0.1:38182";
    forceSSL = true;
    useACMEHost = "within.website";
    extraConfig = ''
      access_log /var/log/nginx/maison.access.log;
    '';
  };

  services.nginx.virtualHosts."olin.within.website" = {
    locations."/".proxyPass = "http://127.0.0.1:25723";
    forceSSL = true;
    useACMEHost = "within.website";
    extraConfig = ''
      access_log /var/log/nginx/olin.access.log;
    '';
  };
}
