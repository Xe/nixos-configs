{ config, pkgs, ... }:
let
  listenPort = 51822;
  hosts = builtins.fromJSON (builtins.readFile ./hosts.json);
in {
  networking.wireguard.interfaces.pele = {
    ips = hosts."${config.networking.hostName}".allowedIPs;
    privateKeyFile = "/root/pele.key";
    inherit listenPort;
    peers = with hosts; [ ns1 ns2 shell ];
  };

  networking.firewall.trustedInterfaces = [ "pele" ];
  networking.nameservers = [ "fdd9:4a1e:bb91:810e::" "fdd9:4a1e:bb91:af30::" ];

  deployment = {
    healthChecks.cmd = [
      {
        cmd = [ "ping" "-6" "-c" "4" "fdd9:4a1e:bb91:810e::" ];
        description = "ping ns1 over wireguard";
      }
      {
        cmd = [ "ping" "-6" "-c" "4" "fdd9:4a1e:bb91:af30::" ];
        description = "ping ns2 over wireguard";
      }
      {
        cmd = [ "ping" "-6" "-c" "4" "fdd9:4a1e:bb91:e6d1::" ];
        description = "ping shell over wireguard";
      }
    ];
    secrets = {
      "wireguard" = {
        source = "./wireguard/secret/${config.networking.hostName}.privkey";
        destination = "/root/pele.key";
        owner.user = "root";
        owner.group = "root";
        permissions = "0400"; # this is the default
      };
    };
  };
}
