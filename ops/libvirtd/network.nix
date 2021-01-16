{
  network = {
    description = "simple hosts";
    deployment.targetUser = "root";
  };

  "ns1" = { config, pkgs, ... }: {
    imports =
      [ ../../common/generic-libvirtd.nix ../../common/coredns ./wireguard ];
    networking.firewall.enable = false;
    networking.nameservers = [ "192.168.122.187" ];

    within.coredns = {
      enable = true;
      addr = "192.168.122.187";
      prometheus.enable = true;
    };

    deployment.targetHost = "192.168.122.187";
    deployment.healthChecks.cmd = [
      {
        cmd = [ "${pkgs.dnsutils}/bin/nslookup shachi.wg.akua" ];
        description = "Testing that dns resolution of shachi.wg.akua works.";
      }
      {
        cmd = [ "ping" "-6" "-c" "4" "fdd9:4a1e:bb91:810e::" ];
        description = "ping ns1 over wireguard";
      }
      {
        cmd = [ "ping" "-6" "-c" "4" "fdd9:4a1e:e6d1:810e::" ];
        description = "ping shell over wireguard";
      }
    ];

    networking.wireguard.interfaces.pele = {
      ips = [ "fdd9:4a1e:bb91:810e::/64" ];
      privateKeyFile = "/root/pele.key";
    };

    deployment.secrets = {
      "wireguard" = {
        source = "./wireguard/secret/ns1.privkey";
        destination = "/root/pele.key";
        owner.user = "root";
        owner.group = "root";
        permissions = "0400"; # this is the default
      };
    };
  };

  "shell" = { config, pkgs, ... }: {
    imports = [ ../../common/generic-libvirtd.nix ./wireguard ];
    networking.firewall.enable = false;
    networking.nameservers = [ "192.168.122.187" ];

    deployment.targetHost = "192.168.122.191";
    deployment.healthChecks.cmd = [
      {
        cmd = [ "${pkgs.dnsutils}/bin/nslookup shachi.wg.akua" ];
        description = "Testing that dns resolution of shachi.wg.akua works.";
      }
      {
        cmd = [ "ping" "-6" "-c" "4" "fdd9:4a1e:bb91:810e::" ];
        description = "ping ns1 over wireguard";
      }
      {
        cmd = [ "ping" "-6" "-c" "4" "fdd9:4a1e:e6d1:810e::" ];
        description = "ping shell over wireguard";
      }
    ];

    networking.wireguard.interfaces.pele = {
      ips = [ "fdd9:4a1e:bb91:e6d1::/64" ];
      privateKeyFile = "/root/pele.key";
    };

    deployment.secrets = {
      "wireguard" = {
        source = "./wireguard/secret/shell.privkey";
        destination = "/root/pele.key";
        owner.user = "root";
        owner.group = "root";
        permissions = "0400"; # this is the default
      };
    };
  };
}
