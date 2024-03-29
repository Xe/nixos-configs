{ lib, config, pkgs, ... }:

let metadata = pkgs.callPackage ../../ops/metadata/peers.nix { };
in {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../common
    ../../common/services
    ../../common/sites/grafana.akua.nix
    ../../common/sites/keyzen.akua.nix
    ../../common/sites/start.akua.nix
    ../../common/users/home-manager.nix
    ./tulpachat.nix
    ./tulpachat-mods.nix
    ./furryhole.nix
    ./josh.nix
    ./prometheus.nix
    ./solanum.nix
    ./znc.nix
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

  # 9p
  services.diod = {
    allsquash = false;
    enable = true;
    exports = [ "/home/cadey" ];
    userdb = true;
    squashuser = "cadey";
  };

  cadey.cpu = {
    enable = true;
    vendor = "intel";
  };

  within.backups = {
    enable = true;
    repo = "57196@usw-s007.rsync.net:chrysalis";
    paths = [
      "/home/cadey/backup"
      "/home/cadey/code"
      "/home/cadey/git"
      "/home/cadey/project"
      "/srv"
      "/var/lib/grafana"
      "/var/lib/prometheus2"
      "/var/lib/tailscale"
      "/var/lib/znc"
    ];
  };

  # monitoring
  services.grafana = {
    enable = true;
    domain = "grafana.akua";
    port = 2342;
    addr = "0.0.0.0";
  };

  services.tailscale.enable = true;

  within.coredns = {
    enable = false;
    addr = "10.77.2.2";
    addServer = true;
    prometheus.enable = true;
  };

  services.avahi = {
    enable = true;
    publish = {
      enable = true;
      addresses = true;
    };
  };

  services.redis = { enable = true; };

  services.corerad = {
    enable = false;
    settings = {
      interfaces = [{
        name = "virbr0";
        advertise = true;
        prefix = [{ prefix = "fd69:420:e621:53f6::/64"; }];
      }];
      debug = {
        address = "10.77.2.2:38177";
        prometheus = true;
      };
    };
  };
}

