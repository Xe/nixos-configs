{
  network.description = "Web server";

  webserver = { config, pkgs, ... }: {
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
