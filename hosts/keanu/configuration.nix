# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  metadata =
    pkgs.callPackage /home/cadey/code/nixos-configs/ops/metadata/peers.nix { };
in {
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

  networking.wireguard.interfaces.akua =
    metadata.hosts."${config.networking.hostName}";

  networking.nameservers = [ "10.77.2.2" ];

  within.backups = {
    enable = true;
    repo = "57196@usw-s007.rsync.net:keanu";
  exclude = [
    # temporary files created by cargo
    "**/target"
    "/srv/share"
    "/srv/backup"
    "/var/lib/docker"
    "/var/lib/systemd"
    "/var/lib/libvirt"
    "'**/.cache'"
    "'**/.nix-profile'"
    "'**/.elm'"
    "'**/.emacs.d'"
  ];
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

  services.avahi = {
    enable = true;
    publish = {
      enable = true;
      addresses = true;
    };
  };

  users.users.share.isNormalUser = false;

  # trick to create a directory with proper ownership
  # note that tmpfiles are not necesserarly temporary if you don't
  # set an expire time. Trick given on irc by someone I forgot the name..
  systemd.tmpfiles.rules = [ "d /srv/share 0755 share users" ];

  services.samba.enable = true;
  services.samba.enableNmbd = true;
  services.samba.extraConfig = ''
    workgroup = WORKGROUP
    server string = Samba Server
    server role = standalone server
    log file = /var/log/samba/smbd.%m
    max log size = 50
    dns proxy = no
    map to guest = Bad User
    browseable = yes
  '';
  services.samba.shares = {
    public = {
      path = "/srv/share";
      browseable = "yes";
      "writable" = "yes";
      "guest ok" = "yes";
      "public" = "yes";
      "force user" = "share";
    };
  };
}

