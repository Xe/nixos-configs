{ config, pkgs, lib, ... }:

{
  imports = [
    ./acme.nix
    ./akua.nix
    ./docker.nix
    ./gitea.nix
    ./hardware-configuration.nix
    ./monitoring.nix
    ./weechat.nix
    ./within.nix
    ./when-then-zen.nix
    ./zrepl.nix

    ../../common
    ../../common/services
    ../../common/users/home-manager.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/nvme0n1"; # or "nodev" for efi only
  boot.kernelParams = [ "zfs.zfs_arc_max=1073741824" ];
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

  services.corerad = {
    enable = false;
    settings = {
      interfaces = [{
        name = "virbr0";
        advertise = true;
        prefix = [{ prefix = "fd69:420:e621:31a4::/64"; }];
      }];
      debug = {
        address = "10.77.3.1:38177";
        prometheus = true;
      };
    };
  };

  boot.supportedFilesystems = [ "zfs" ];

  environment.systemPackages = with pkgs; [ wget vim zfs weechat tailscale ];

  networking.firewall = {
    enable = false;
    allowedTCPPorts = [ 22 80 443 1965 6667 6697 ];
    allowedUDPPorts = [ 41641 51822 51820 ];

    allowedUDPPortRanges = [{
      from = 32768;
      to = 65535;
    }];

    trustedInterfaces = [ "akua" "tailscale0" ];
  };

  system.stateVersion = "20.09"; # Did you read the comment?

  cadey.cpu = {
    enable = true;
    vendor = "amd";
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
  virtualisation.docker.storageDriver = "zfs";
  virtualisation.libvirtd.enable = true;

  systemd.services.nginx.serviceConfig.SupplementaryGroups = "within";
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    statusPage = true;
    enableReload = true;
    commonHttpConfig = ''
      set_real_ip_from 103.21.244.0/22;
      set_real_ip_from 103.22.200.0/22;
      set_real_ip_from 103.31.4.0/22;
      set_real_ip_from 104.16.0.0/13;
      set_real_ip_from 104.24.0.0/14;
      set_real_ip_from 108.162.192.0/18;
      set_real_ip_from 131.0.72.0/22;
      set_real_ip_from 141.101.64.0/18;
      set_real_ip_from 162.158.0.0/15;
      set_real_ip_from 172.64.0.0/13;
      set_real_ip_from 173.245.48.0/20;
      set_real_ip_from 188.114.96.0/20;
      set_real_ip_from 190.93.240.0/20;
      set_real_ip_from 197.234.240.0/22;
      set_real_ip_from 198.41.128.0/17;
      set_real_ip_from 2400:cb00::/32;
      set_real_ip_from 2606:4700::/32;
      set_real_ip_from 2803:f800::/32;
      set_real_ip_from 2405:b500::/32;
      set_real_ip_from 2405:8100::/32;
      set_real_ip_from 2c0f:f248::/32;
      set_real_ip_from 2a06:98c0::/29;
      real_ip_header CF-Connecting-IP;
    '';

    virtualHosts."withinwebsite" = {
      locations = {
        "/.well-known/matrix/server".extraConfig =
          let
            # use 443 instead of the default 8448 port to unite
            # the client-server and server-server port for simplicity
            server = { "m.server" = "matrix.within.website:443"; };
          in ''
            add_header Content-Type application/json;
            return 200 '${builtins.toJSON server}';
          '';

        "/.well-known/matrix/client".extraConfig =
          let
            client = {
              "m.homeserver" =  { "base_url" = "https://matrix.within.website"; };
            };
          # ACAO required to allow riot-web on any URL to request this json file
          in ''
            add_header Content-Type application/json;
            add_header Access-Control-Allow-Origin *;
            return 200 '${builtins.toJSON client}';
          '';
      };
    };
  };

  services.tailscale.enable = true;

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    settings.mysqld.bind-address = "127.0.0.1";
  };

  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot = {
    enable = true;
    monthly = 1;
  };

  services.yggdrasil = {
    enable = true;
    persistentKeys = true;
    openMulticastPort = true;
    config = {
      IfName = "yggdrasil0";
      Peers = [
        "tls://94.103.82.150:8080"
        "tcp://ams1.y.sota.sh:8080"
        "tls://45.147.198.155:6010"
        "tls://ygg-nl.incognet.io:8884"
      ];
    };
  };
}
