{ writeTextFile, lib, ... }:

let
  metadata = lib.importTOML ./hosts.toml;
  roamPeer = { network, wireguard, ... }:
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
  serverPeer = { network, wireguard, ip_addr, ... }:
    let
      net = metadata.networks."${network}";
      v6subnet = net.ula;
    in {
      allowedIPs = [
        "${metadata.common.ula}:${wireguard.addrs.v6}/128"
        "${metadata.common.gua}:${wireguard.addrs.v6}/128"
        "${wireguard.addrs.v4}/32"
      ] ++ (if ip_addr == "10.77.3.1" then [ "10.77.0.0/16" ] else [ ]);
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
  mkClientConfig = { network, wireguard, ... }:
    name:
    let
      net = metadata.networks."${network}";
      v6subnet = net.ula;
    in with metadata.hosts;
    writeTextFile {
      name = "${name}.conf";
      text = ''
        [Interface]
        Address = ${wireguard.addrs.v4}/16, ${metadata.common.ula}:${wireguard.addrs.v6}/48, "${metadata.common.gua}:${wireguard.addrs.v6}/48
        ListenPort = 0
        DNS = ${firgu.wireguard.addrs.v4}
        PrivateKey = FILL_ME_IN

        # firgu is the primary router
        [Peer]
        PublicKey = ${firgu.wireguard.pubkey}
        AllowedIPs = ${metadata.common.v4}/16, ${metadata.common.ula}::/48, ${metadata.common.gua}::/48
        Endpoint = ${firgu.ip_addr}:${toString firgu.wireguard.port}

        [Peer]
        PublicKey = ${lufta.wireguard.pubkey}
        AllowedIPs = ${lufta.wireguard.addrs.v4}/32, ${metadata.common.ula}:${lufta.wireguard.addrs.v6}/128, ${metadata.common.gua}:${lufta.wireguard.addrs.v6}/128
        Endpoint = ${lufta.ip_addr}:${toString lufta.wireguard.port}
      '';
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
  ];

  cloud = [
    # roadwarrior
    (roamPeer la-tahorskami)
    (roamPeer la-selbeifonxa)
    (roamPeer tolsutra)
    # hexagone
    (roamPeer chrysalis)
    (roamPeer keanu)
    (roamPeer shachi)
    (roamPeer genza)
    # cloud
    (serverPeer lufta)
    (serverPeer firgu)
    (serverPeer kahless)
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

  confs = {
    la-tahorskami = mkClientConfig la-tahorskami "la-tahorskami";
    la-selbeifonxa = mkClientConfig la-selbeifonxa "la-selbeifonxa";
    tolsutra = mkClientConfig tolsutra "tolsutra";
  };
}
