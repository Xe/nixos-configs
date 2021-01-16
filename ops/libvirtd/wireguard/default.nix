{ ... }:
let listenPort = 51822;
in {
  networking.wireguard.interfaces.pele = {
    inherit listenPort;
    peers = [
      # ns1
      {
        allowedIPs = [ "fdd9:4a1e:bb91:810e::/64" ];
        publicKey = "QmoBSiBT92pBx+QrP2OgaAMI+pPULdG0nwsrETKKeS0=";
        endpoint = "192.168.122.187:${toString listenPort}";
        persistentKeepalive = 25;
      }

      # shell
      {
        allowedIPs = [ "fdd9:4a1e:bb91:e6d1::/64" ];
        publicKey = "N/BF91qksWD8akPKIWTZ2KbIxyxxap1mxTj59c1tr3E=";
        endpoint = "192.168.122.191:${toString listenPort}";
        persistentKeepalive = 25;
      }
    ];
  };
}
