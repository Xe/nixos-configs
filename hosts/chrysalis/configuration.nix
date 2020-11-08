{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    /home/cadey/code/nixos-configs/common/users
    /home/cadey/code/nixos-configs/common/base.nix
    /home/cadey/code/nixos-configs/common/sites/keyzen.akua.nix
    /home/cadey/code/nixos-configs/common/sites/start.akua.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "chrysalis"; # Define your hostname.
  networking.useDHCP = false;
  networking.interfaces.enp11s0.useDHCP = true;
  networking.interfaces.enp12s0.useDHCP = true;

  time.timeZone = "America/Toronto";

  environment.systemPackages = with pkgs; [ wget vim ];

  services.openssh.enable = true;

  networking.firewall.enable = false;

  system.stateVersion = "20.09";
  nixpkgs.config.allowUnfree = true;

  services.nginx.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;

  # Akua
  networking.wireguard.interfaces = {
    akua = {
      ips = [ "10.77.2.2/16" "fda2:d982:1da2:ed22::/64" ];

      privateKeyFile = "/root/wireguard-keys/private";
      listenPort = 51822;

      peers = [
        # kahless
        {
          allowedIPs = [ "10.77.0.0/16" "10.88.0.0/16" "fda2:d982:1da2::/48" ];
          publicKey = "MvBR3bV1TfACKcF5LQmLL3xlzpdDEatg5dHEyNKA5mw=";
          endpoint = "kahless.cetacean.club:51820";
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
          endpoint = "192.168.0.177:51820";
          persistentKeepalive = 25;
        }

        # keanu
        {
          allowedIPs = [ "10.77.2.1/32" "fda2:d982:1da2:8265::/64" ];
          publicKey = "Dh0D2bdtSmx1Udvuwh7BdWuCADsHEfgWy8usHc1SJkU=";
          endpoint = "192.168.0.128:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  # 9p
  services.diod = {
    allsquash = false;
    enable = true;
    exports = [
      "/home/cadey"
    ];
    userdb = true;
    squashuser = "cadey";
  };

  cadey.cpu = {
    enable = true;
    vendor = "intel";
  };

  within.services = {
    tron.enable = true;
  };
}

