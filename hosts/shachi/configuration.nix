# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  metadata =
    pkgs.callPackage /home/cadey/code/nixos-configs/ops/metadata/peers.nix { };
in {
  imports = [
    ./dns.nix
    ./hardware-configuration.nix
    /home/cadey/code/nixos-configs/common/users
    /home/cadey/code/nixos-configs/common/base.nix
    /home/cadey/code/nixos-configs/common/desktop.nix
    /home/cadey/code/nixos-configs/common/programs/plex.nix
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
      package = pkgs.tailscale;
    };
  };

  networking.wireguard.interfaces.akua =
    metadata.hosts."${config.networking.hostName}";

  services.prometheus = {
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
      };
      wireguard.enable = true;
    };
  };

  programs.mtr.enable = true;

  services.tor.enable = true;

  services.borgbackup.jobs."rsyncnet" = {
    paths = [
      "/home/cadey/.ssh"
      "/home/cadey/code/nixos-configs"
      "/home/cadey/books"
      "/home/cadey/Pictures"
      "/home/cadey/Documents"
      "/home/cadey/sm64_save_file.bin"
      "/root"
      "/var/lib/minecraft"
    ];
    exclude = [
      # temporary files created by cargo
      "**/target"
    ];
    repo = "57196@usw-s007.rsync.net:shachi";
    encryption = {
      mode = "repokey-blake2";
      passCommand = "cat /root/borg_passphrase";
    };
    environment.BORG_RSH = "ssh -i /root/borg_ssh_key";
    compression = "auto,lzma";
    startAt = "daily";
  };

  services.avahi = {
    enable = true;
    publish = {
      enable = true;
      addresses = true;
    };
  };

  services.samba = {
    enable = true;
    nsswins = true;
    shares = {
      data = {
        path = "/data";
        "read only" = false;
        browseable = "yes";
        "guest ok" = "yes";
        comment = "Public samba share.";
      };
    };
  };

  services.minecraft-server = {
    enable = true;
    eula = true; # set to true if you agree to Mojang's EULA: https://account.mojang.com/documents/minecraft_eula
    declarative = true;

    # see here for more info: https://minecraft.gamepedia.com/Server.properties#server.properties
    serverProperties = {
      server-port = 25565;
      gamemode = "survival";
      motd = "NixOS Minecraft server on Tailscale!";
      max-players = 20;
      enable-rcon = true;
      # This password can be used to administer your minecraft server.
      # Exact details as to how will be explained later. If you want
      # you can replace this with another password.
      "rcon.password" = "hunter2";
      level-seed = "10292992";
    };
  };
}
