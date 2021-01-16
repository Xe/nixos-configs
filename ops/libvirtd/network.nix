let hosts = builtins.fromJSON (builtins.readFile ./wireguard/hosts.json);
in {
  network = {
    description = "simple hosts";
    deployment.targetUser = "root";
  };

  "ns1" = { config, pkgs, lib, ... }: {
    imports =
      [ ../../common/generic-libvirtd.nix ../../common/coredns ./wireguard ];
    networking.firewall.allowedUDPPorts = [ 53 ];
    networking.nameservers = lib.mkForce [ "192.168.122.187" ];

    within.coredns = {
      enable = true;
      addr = "192.168.122.187";
    };

    deployment.targetHost = "192.168.122.187";
    deployment.healthChecks.cmd = [{
      cmd = [ "${pkgs.dnsutils}/bin/nslookup shachi.wg.akua" ];
      description = "Testing that dns resolution of shachi.wg.akua works.";
    }];
  };

  "ns2" = { config, pkgs, lib, ... }: {
    imports =
      [ ../../common/generic-libvirtd.nix ../../common/coredns ./wireguard ];
    networking.firewall.allowedUDPPorts = [ 53 ];
    networking.nameservers = lib.mkForce [ "192.168.122.80" ];

    within.coredns = {
      enable = true;
      addr = "192.168.122.80";
    };

    deployment.targetHost = "192.168.122.80";
    deployment.healthChecks.cmd = [{
      cmd = [ "${pkgs.dnsutils}/bin/nslookup shachi.wg.akua" ];
      description = "Testing that dns resolution of shachi.wg.akua works.";
    }];
  };

  "shell" = { config, pkgs, ... }: {
    imports = [ ../../common/generic-libvirtd.nix ./wireguard ];
    networking.firewall.enable = false;

    deployment.targetHost = "192.168.122.191";
    deployment.healthChecks.cmd = [{
      cmd = [ "${pkgs.dnsutils}/bin/nslookup shachi.wg.akua" ];
      description = "Testing that dns resolution of shachi.wg.akua works.";
    }];
  };
}
