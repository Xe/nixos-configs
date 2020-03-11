{ config, pkgs, ... }:

{
  networking.wireguard.interfaces = {
    akua = {
      ips = [ "10.77.2.8/16" "fda2:d982:1da2:2::8/128" ];

      privateKeyFile = "/root/wireguard-keys/private";

      peers = [
        # kahless
        {
          allowedIPs = [ "10.77.0.0/16" "fda2:d982:1da2::/48" ];
          publicKey = "MvBR3bV1TfACKcF5LQmLL3xlzpdDEatg5dHEyNKA5mw=";
          endpoint = "kahless.cetacean.club:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
