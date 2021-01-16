{
  network = {
    description = "simple hosts";
    deployment.targetUser = "root";
  };

  "ns1" = { config, pkgs, ... }: {
    imports = [ ../../common/generic-libvirtd.nix ../../common/coredns ];
    networking.firewall.enable = false;
    networking.nameservers = [ "192.168.122.187" ];

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

  "shell" = { config, pkgs, ... }: {
    imports = [ ../../common/generic-libvirtd.nix ];
    networking.firewall.enable = false;
    networking.nameservers = [ "192.168.122.187" ];

    deployment.targetHost = "192.168.122.191";
    deployment.healthChecks.cmd = [{
      cmd = [ "${pkgs.dnsutils}/bin/nslookup shachi.wg.akua" ];
      description = "Testing that dns resolution of shachi.wg.akua works.";
    }];
  };
}
