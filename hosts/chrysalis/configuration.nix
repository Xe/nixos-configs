{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    /home/cadey/code/nixos-configs/common/users
    /home/cadey/code/nixos-configs/common/base.nix
    /home/cadey/code/nixos-configs/common/sites/grafana.akua.nix
    /home/cadey/code/nixos-configs/common/sites/keyzen.akua.nix
    /home/cadey/code/nixos-configs/common/sites/start.akua.nix
    /home/cadey/code/nixos-configs/common/services
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

        # keanu
        {
          allowedIPs = [ "10.77.2.1/32" "fda2:d982:1da2:8265::/64" ];
          publicKey = "Dh0D2bdtSmx1Udvuwh7BdWuCADsHEfgWy8usHc1SJkU=";
          endpoint = "192.168.0.159:51820";
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
          endpoint = "192.168.0.179:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };

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

  within = {
    backups = {
      enable = true;
      repo = "o6h6zl22@o6h6zl22.repo.borgbase.com:repo";
    };

    services = {
      mi = {
        enable = true;
        domain = "mi.within.website";
        port = 28384;
      };

      tron.enable = true;
      withinbot.enable = true;
    };
  };

  # monitoring
  services.grafana = {
    enable = true;
    domain = "grafana.akua";
    port = 2342;
    addr = "0.0.0.0";
  };

  services.loki = {
    enable = true;
    configFile = ./loki-local-config.yaml;
  };

  services.prometheus = {
    enable = true;
    scrapeConfigs = [
      {
        job_name = "mi";
        static_configs = [{ targets = [ "127.0.0.1:28384" ]; }];
      }
      {
        job_name = "site";
        scheme = "https";
        static_configs = [{ targets = [ "christine.website" ]; }];
      }
      {
        job_name = "chrysalis";
        static_configs = [{ targets = [ "10.77.2.2:9100" "10.77.2.2:9586" ]; }];
      }
      {
        job_name = "keanu";
        static_configs = [{ targets = [ "10.77.2.1:9100" "10.77.2.1:9586" ]; }];
      }
    ];

    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
      };
      wireguard.enable = true;
    };
  };

  systemd.services.promtail = {
    description = "Promtail service for Loki";
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = ''
        ${pkgs.grafana-loki}/bin/promtail --config.file ${./promtail.yaml}
      '';
    };
  };

  services.tor = {
    enable = true;

    hiddenServices = {
      "hunt" = {
        name = "hunt";
        version = 3;
        map = [{
          port = 80;
          toPort = 80;
        }];
      };
    };
  };

  services.nginx = {
    appendHttpConfig = ''
      server_names_hash_bucket_size 1024;
    '';
    virtualHosts."yvzvgjiuz5tkhfuhvjqroybx6d7swzzcaia2qkgeskhu4tv76xiplwad.onion" =
      {
        root = "/srv/http/marahunt";
      };
  };
}

