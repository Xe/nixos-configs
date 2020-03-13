{
  network.description = "Web server";

  webserver = { config, pkgs, ... }: {
    services.tor.enable = true;
    services.tor.hiddenServices = {
      "http" = {
        map = [ {port = 80; } ];
        name = "http";
        version = 3;
      };
    };

    docker-containers."nginx" = {
      image = "nginx:latest";
      environment = {
        "FOO" = "bar";
      };
      ports = [ "80:80" ];
    };

    networking.firewall.allowedTCPPorts = [ 80 ];
  };
}
