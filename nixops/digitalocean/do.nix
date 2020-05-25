{
  resources.sshKeyPairs.ssh-key = {};

  machine = { config, pkgs, ... }: {
    imports = [
      ../../common/xeserv
    ];

    services.nginx.enable = true;
    services.openssh.enable = true;

    networking.hostName = "dilnu";

    deployment.targetEnv = "digitalOcean";
    deployment.digitalOcean.enableIpv6 = true;
    deployment.digitalOcean.region = "nyc3";
    deployment.digitalOcean.size = "s-1vcpu-1gb";
  };
}
