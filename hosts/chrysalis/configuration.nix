{ config, pkgs, ... }:

let metadata = pkgs.callPackage ../../ops/metadata/peers.nix { };
in {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../common/base.nix
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

  networking.wireguard.interfaces.akua =
    metadata.hosts."${config.networking.hostName}";

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
  };

  # monitoring
  services.grafana = {
    enable = true;
    domain = "grafana.akua";
    port = 2342;
    addr = "0.0.0.0";
  };

  services.tailscale.enable = true;

  services.nginx = {
    appendHttpConfig = ''
      server_names_hash_bucket_size 1024;
    '';
    virtualHosts."100.97.53.92".locations."/" = {
      root = "/srv/http/iso";
      extraConfig = "autoindex on;";
    };
  };

  within.coredns = {
    enable = true;
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
}

