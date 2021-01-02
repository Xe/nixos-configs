# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    /home/cadey/code/nixos-configs/common/users
    /home/cadey/code/nixos-configs/common/base.nix
    /home/cadey/code/nixos-configs/common/desktop.nix
    /home/cadey/code/nixos-configs/common/programs/plex.nix
    /home/cadey/code/nixos-configs/common/programs/samba.nix
    ./rhea.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # 4 TB drive
  boot.supportedFilesystems = [ "ntfs" ];

  fileSystems."/data" = {
    device = "/dev/disk/by-uuid/8464C10764C0FCC4";
    fsType = "ntfs";
    options = [ "rw" "uid=1001" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/03CF-4140";
    fsType = "vfat";
  };

  networking.hostName = "shachi"; # Define your hostname.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp4s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console.font = "Lat2-Terminus16";

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    vim
    logitech-udev-rules
    ltunify
    lagrange
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # bluetooth
  hardware.bluetooth.enable = true;

  # make steam work
  hardware.opengl.driSupport32Bit = true;
  hardware.steam-hardware.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;

  virtualisation.libvirtd.enable = true;
  networking.firewall.checkReversePath = false;

  services.xserver.videoDrivers = [ "amdgpu" ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.09"; # Did you read the comment?

  programs.adb.enable = true;
  services.tailscale.enable = true;

  cadey = {
    colemak.enable = true;
    cpu = {
      enable = true;
      vendor = "amd";
    };
    tailscale = {
      enable = false;
      notifySupport = false;
      package = pkgs.xxx.hack.tailscale;
    };
  };

  # Akua
  networking.wireguard.interfaces = {
    akua = {
      ips =
        [ "10.77.2.8/16" "fda2:d982:1da2:2::8/128" "fda2:d982:1da2:8::/64" ];

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

        # lufta
        {
          publicKey = "GJMOmAHUXQ7NfAMuEKQ7zhMmd1TIuJKKGYiC8hVpgEU=";
          allowedIPs = [ "10.77.3.1/32" "fda2:d982:1da2:4711::/64" ];
          endpoint = "135.181.162.99:51822";
          persistentKeepalive = 25;
        }

        # keanu
        {
          allowedIPs = [ "10.77.2.1/32" "fda2:d982:1da2:8265::/64" ];
          publicKey = "Dh0D2bdtSmx1Udvuwh7BdWuCADsHEfgWy8usHc1SJkU=";
          endpoint = "192.168.0.159:51820";
          persistentKeepalive = 25;
        }

        # chrysalis
        {
          allowedIPs = [ "10.77.2.2/32" "fda2:d982:1da2:ed22::/64" ];
          publicKey = "Um46toyF9DPeyQWmy4nyyxJH/m37HWXcX+ncJa3Mg0A=";
          endpoint = "192.168.0.127:51822";
          persistentKeepalive = 25;
        }
      ];
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

  services.prometheus = {
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
      };
      wireguard.enable = true;
    };
  };
}
