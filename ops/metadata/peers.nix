{ lib, ... }:

let
  metadata = lib.importTOML ./hosts.toml;
  roamPeer = { network, wireguard, ip_addr ? null, ... }:
    let
      net = metadata.networks."${network}";
      v6subnet = net.ula;
    in {
      allowedIPs = [
        "${metadata.common.ula}:${wireguard.addrs.v6}/128"
        "${metadata.common.gua}:${wireguard.addrs.v6}/128"
        "${wireguard.addrs.v4}/32"
      ];
      publicKey = wireguard.pubkey;
    };
  serverPeer = { network, wireguard, ip_addr ? null, ... }:
    let
      net = metadata.networks."${network}";
      v6subnet = net.ula;
    in {
      allowedIPs = [
        "${metadata.common.ula}:${wireguard.addrs.v6}/128"
        "${metadata.common.gua}:${wireguard.addrs.v6}/128"
        "${wireguard.addrs.v4}/32"
      ];
      publicKey = wireguard.pubkey;
      persistentKeepalive = 25;
    };
in with metadata.hosts; {
  hexagone = [
    (serverPeer lufta)
    (serverPeer firgu)
    (serverPeer chrysalis)
    (serverPeer keanu)
  ];
  cloud = [
    (roamPeer la-tahorskami)
    (roamPeer la-selbeifonxa)
    (roamPeer tolsutra)
    (roamPeer chrysalis)
    (roamPeer keanu)
    (serverPeer lufta)
    (serverPeer firgu)
  ];
}
