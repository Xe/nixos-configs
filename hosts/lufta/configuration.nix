{ config, pkgs, ... }:

{
  imports = [
    ./acme.nix
    ./docker.nix
    ./gitea.nix
    ./hardware-configuration.nix
    ./weechat.nix
    ./within.nix
    ./when-then-zen.nix

    /home/cadey/code/nixos-configs/common/users
    /home/cadey/code/nixos-configs/common/base.nix
    /home/cadey/code/nixos-configs/common/services
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/nvme0n1"; # or "nodev" for efi only
  boot.zfs.devNodes = "/dev/disk/by-partuuid";

  networking.hostName = "lufta"; # Define your hostname.
  networking.hostId = "2487cd1f";
  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = false;

  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPg9gYKVglnO2HQodSJt4z4mNrUSUiyJQ7b+J798bwD9 cadey@shachi"
  ];

  networking.usePredictableInterfaceNames = false;
  systemd.network = {
    enable = true;
    networks."eth0".extraConfig = ''
      [Match]
      Name = eth0
      [Network]
      # Add your own assigned ipv6 subnet here here!
      Address = 2a01:4f9:3a:1a1c::/64
      Gateway = fe80::1
      # optionally you can do the same for ipv4 and disable DHCP (networking.dhcpcd.enable = false;)
      Address =  135.181.162.99/26
      Gateway = 135.181.162.65
    '';
  };

  boot.supportedFilesystems = [ "zfs" ];

  environment.systemPackages = with pkgs; [ wget vim zfs weechat tailscale ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  networking.firewall.allowedTCPPorts = [ 22 80 443 6667 6697 ];
  networking.firewall.allowedUDPPorts = [ 51822 ];
  networking.firewall.enable = false;

  system.stateVersion = "20.09"; # Did you read the comment?

  cadey.cpu = {
    enable = true;
    vendor = "amd";
  };

  services.prometheus = {
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
      };
      wireguard.enable = true;
    };
  };

  services.cfdyndns = {
    enable = true;
    email = "shadow.h511@gmail.com";
    apikeyFile = "${pkgs.writeTextFile {
      text = builtins.readFile ./secret/cf-api-key;
      name = "cf.key";
    }}";
    records = [ "lufta.cetacean.club" ];
  };

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };

  services.tailscale.enable = true;
  services.tor.enable = true;
  services.mysql.enable = true;
  services.mysql.package = pkgs.mariadb;

  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot = {
    enable = true;
    monthly = 1;
  };

  networking.wireguard.interfaces = {
    akua = {
      ips = [ "10.77.3.1/16" "fda2:d982:1da2:4711::/64" ];

      privateKeyFile = "/root/wireguard-keys/private";
      listenPort = 51822;

      peers = [
        # kahless
        {
          allowedIPs = [ "10.77.0.0/16" "10.88.0.0/16" "fda2:d982:1da2::/48" ];
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
      ];
    };
  };
}
