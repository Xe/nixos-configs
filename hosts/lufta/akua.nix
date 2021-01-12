{ ... }:

{
  networking.wireguard.interfaces = {
    akua = {
      ips = [ "10.77.3.1/16" "fda2:d982:1da2:4711::/64" ];

      privateKeyFile = "/root/wireguard-keys/private";
      listenPort = 51822;

      peers = [
        ## servers

        # kahless
        {
          allowedIPs = [ "10.77.0.0/16" "fda2:d982:1da2::/48" ];
          publicKey = "MvBR3bV1TfACKcF5LQmLL3xlzpdDEatg5dHEyNKA5mw=";
          endpoint = "198.27.67.207:51820";
          persistentKeepalive = 25;
        }

        # chrysalis
        {
          allowedIPs = [ "10.77.2.2/32" "fda2:d982:1da2:ed22::/64" ];
          publicKey = "Um46toyF9DPeyQWmy4nyyxJH/m37HWXcX+ncJa3Mg0A=";
          persistentKeepalive = 25;
        }

        # keanu
        {
          allowedIPs = [ "10.77.2.1/32" "fda2:d982:1da2:8265::/64" ];
          publicKey = "Dh0D2bdtSmx1Udvuwh7BdWuCADsHEfgWy8usHc1SJkU=";
          persistentKeepalive = 25;
        }

        # shachi
        {
          allowedIPs = [
            "10.77.2.8/32"
            "fda2:d982:1da2:2::8/128"
            "fda2:d982:1da2:8::/64"
          ];
          publicKey = "S8XgS18Z8xiKwed6wu9FE/JEp1a/tFRemSgfUl3JPFw=";
          persistentKeepalive = 25;
        }

        # minipaas
        {
          allowedIPs = [ "10.77.0.8/32" "fda2:d982:1da2::8/128" ];
          publicKey = "AZjslPDu1Fb2+vWAR8NJzUSsA38rxGo+634y8M9yAkI=";
          endpoint = "165.227.53.75:51820";
          persistentKeepalive = 25;
        }

        ## devices

        # la ta'orskami
        {
          allowedIPs = [ "10.77.1.1/32" "fda2:d982:1da2:425e::/64" ];
          publicKey = "d/0BCLjiJjxftyBrEOSoxUhz2FHxvKwgOA/hX73NpQ8=";
        }

        # la selbeifonxa
        {
          allowedIPs = [ "10.77.1.2/32" "fda2:d982:1da2:59d7::/64" ];
          publicKey = "2eu4fh8STQDB1aeFP9C7nRyeOmw3k2ba/WpEBPJ5wmc=";
        }

        # tolsutra
        {
          allowedIPs = [ "10.77.1.3/32" "fda2:d982:1da2:74f2::/64" ];
          publicKey = "tDQlTm35G9LT9GE+VX1gWgnd2i9dmsmC6hSnTjiOBXM=";
        }
      ];
    };
  };
}
