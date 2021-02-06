{ writeTextFile, lib, ... }:

let
  metadata = lib.importTOML ./hosts.toml;
  roamPeer = { network, wireguard, ... }:
    let
      net = metadata.networks."${network}";
      v6subnet = net.ula;
      extraAddrs = ({ extra_addrs ? [ ], ... }: extra_addrs) wireguard;
    in {
      allowedIPs = [
        "${metadata.common.ula}:${wireguard.addrs.v6}/128"
        "${metadata.common.gua}:${wireguard.addrs.v6}/128"
        "${wireguard.addrs.v4}/32"
      ] ++ extraAddrs;
      publicKey = wireguard.pubkey;
    };
  serverPeer = { network, wireguard, ip_addr, ... }:
    let
      net = metadata.networks."${network}";
      v6subnet = net.ula;
      extraAddrs = ({ extra_addrs ? [ ], ... }: extra_addrs) wireguard;
    in {
      allowedIPs = [
        "${metadata.common.ula}:${wireguard.addrs.v6}/128"
        "${metadata.common.gua}:${wireguard.addrs.v6}/128"
        "${wireguard.addrs.v4}/32"
      ] ++ (if ip_addr == "10.77.3.1" then [ "10.77.0.0/16" ] else [ ])
        ++ extraAddrs;
      publicKey = wireguard.pubkey;
      persistentKeepalive = 25;
      endpoint = "${ip_addr}:${toString wireguard.port}";
    };
  interfaceInfo = { network, wireguard, ... }:
    peers:
    let
      net = metadata.networks."${network}";
      v6subnet = net.ula;
    in {
      ips = [
        "${metadata.common.ula}:${wireguard.addrs.v6}/128"
        "${metadata.common.gua}:${wireguard.addrs.v6}/128"
        "${wireguard.addrs.v4}/32"
      ];
      privateKeyFile = "/root/wireguard-keys/private";
      listenPort = wireguard.port;
      inherit peers;
    };
in with metadata.hosts; rec {
  # expected peer lists
  hexagone = [
    # cloud
    (serverPeer lufta)
    (serverPeer firgu)
    (serverPeer kahless)
    # hexagone
    (serverPeer chrysalis)
    (serverPeer keanu)
    (serverPeer shachi)
    (serverPeer genza)
    # fake
    (roamPeer httpserver)
  ];

  cloud = [
    # hexagone
    (roamPeer chrysalis)
    (roamPeer keanu)
    (roamPeer shachi)
    (roamPeer genza)
    # cloud
    (serverPeer lufta)
    (serverPeer firgu)
    (serverPeer kahless)
    # fake
    (roamPeer httpserver)
  ];

  roadwarrior = [ (serverPeer lufta) (serverPeer firgu) ];

  hosts = {
    # hexagone
    chrysalis = interfaceInfo chrysalis hexagone;
    keanu = interfaceInfo keanu hexagone;
    shachi = interfaceInfo shachi hexagone;

    # cloud
    lufta = interfaceInfo lufta cloud;
    firgu = interfaceInfo firgu cloud;

    # roadwarrior
    genza = interfaceInfo genza hexagone;
  };
}
