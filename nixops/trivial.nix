{
  network.description = "Web server";

  webserver = { config, pkgs, ... }: {
    services.nginx.enable = true;
    services.nginx.virtualHosts."foo.localhost.cetacean.club" = {
      root = "${pkgs.valgrind.doc}/share/doc/valgrind/html";
    };
    networking.firewall.allowedTCPPorts = [ 80 ];
  };
}
