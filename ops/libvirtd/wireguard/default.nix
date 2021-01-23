{ config, pkgs, ... }:
let
  listenPort = 51822;
  hosts = builtins.fromJSON (builtins.readFile ./hosts.json);
in {
  networking.wireguard.interfaces.pele = {
    ips = hosts."${config.networking.hostName}".allowedIPs;
    privateKeyFile = "/root/pele.key";
    inherit listenPort;
    peers = with hosts; [ pa re ci ];
  };

  networking.firewall.trustedInterfaces = [ "pele" ];
  networking.nameservers = [
    "192.168.122.187"
    "192.168.122.80"
    "fdd9:4a1e:bb91:810e::"
    "fdd9:4a1e:bb91:af30::"
  ];

  deployment = {
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
