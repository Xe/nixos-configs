# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./tunnelbroker.nix

    ../../common/base.nix
    ../../common/services
    ../../common/users/home-manager.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];

  networking.hostId = "babecafe";
  networking.hostName = "keanu"; # Define your hostname.
  networking.useDHCP = false;
  networking.interfaces.enp3s0f2.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;

  time.timeZone = "America/Toronto";

  services.openssh.enable = true;

  networking.firewall = {
    enable = false;
    allowedTCPPorts = [ 22 80 443 ];
    allowedUDPPorts = [ 51820 ];
    trustedInterfaces = [ "enp3s0f2" ];
  };

  system.stateVersion = "20.09"; # Did you read the comment?

  services.logind.lidSwitch = "ignore";

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;

  services.prometheus = {
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
      };
      wireguard.enable = true;
    };
  };

  cadey.cpu = {
    enable = true;
    vendor = "intel";
  };

  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot = {
    enable = true;
    monthly = 1;
  };

  networking.wireguard.interfaces = {
    akua = {
      ips = [ "10.77.2.1/16" "fda2:d982:1da2:8265::/64" ];

      privateKeyFile = "/root/wireguard-keys/private";
      listenPort = 51820;

      peers = [
        # kahless
        {
          allowedIPs = [ "10.77.0.0/16" "10.88.0.0/16" "fda2:d982:1da2::/48" ];
          publicKey = "MvBR3bV1TfACKcF5LQmLL3xlzpdDEatg5dHEyNKA5mw=";
          endpoint = "kahless.cetacean.club:51820";
          persistentKeepalive = 25;
        }

        # chrysalis
        {
          allowedIPs = [ "10.77.2.2/32" "fda2:d982:1da2:ed22::/64" ];
          publicKey = "Um46toyF9DPeyQWmy4nyyxJH/m37HWXcX+ncJa3Mg0A=";
          endpoint = "192.168.0.127:51822";
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
          endpoint = "192.168.0.176:51820";
          persistentKeepalive = 25;
        }

        # lufta
        {
          publicKey = "GJMOmAHUXQ7NfAMuEKQ7zhMmd1TIuJKKGYiC8hVpgEU=";
          allowedIPs = [ "10.77.3.1/32" "fda2:d982:1da2:4711::/64" ];
          endpoint = "135.181.162.99:51822";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  networking.nameservers = [ "10.77.2.2" ];

  within.backups = {
    enable = true;
    repo = "57196@usw-s007.rsync.net:keanu";
  };

  networking.nat.enable = true;
  networking.nat.internalInterfaces = [ "ve-+" ];
  networking.nat.externalInterface = "enp3s0f2";

  containers.sshbox = {
    hostAddress = "10.255.0.0";
    localAddress = "10.255.0.1";
    hostAddress6 = "2001:470:1d:4ee:4fcf:cb3c:0a8c:40c7";
    localAddress6 = "2001:470:1d:4ee:6b67:96d0:8cb3:7b12";
    privateNetwork = true;
    autoStart = true;
    config = let
      fetchKeys = username:
        (builtins.fetchurl "https://github.com/${username}.keys");
    in { pkgs, ... }: {
      imports = [ ../../common/base.nix ];
      services.openssh.enable = true;
      users.users.root.openssh.authorizedKeys.keyFiles = [ (fetchKeys "Xe") ];
    };
  };

  security.acme.acceptTerms = true;
  security.acme.email = "cadey@firemail.cc";

  services.nginx = {
    enable = true;
    virtualHosts."keanu.hexagone.within.website" = {
      addSSL = true;
      enableACME = true;
      locations."/".root = "/srv/http/keanu.hexagone.within.website";
    };
  };
}

