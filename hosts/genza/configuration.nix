{ config, pkgs, lib, ... }:

let
  metadata =
    pkgs.callPackage /home/cadey/code/nixos-configs/ops/metadata/peers.nix { };
in {
  imports = [
    ./hardware-configuration.nix
    ../../common
    ../../common/desktop.nix
    <home-manager/nixos>
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "zfs.zfs_arc_max=1073741824" ];
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.devNodes = "/dev/disk/by-partuuid";

  networking.hostName = "genza"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.hostId = "bddd8eb7";
  services.tailscale.enable = true;

  time.timeZone = "America/Toronto";

  networking.useDHCP = false;
  networking.interfaces.wlp2s0.useDHCP = true;

  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;
hardware.pulseaudio.support32Bit = true;

  services.xserver.libinput.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;

  home-manager.users.cadey =
    (import /home/cadey/code/nixos-configs/common/users/cadey/gui.nix);

  environment.systemPackages = with pkgs; [
    wget
    vim
    firefox
    file
    gimp
    openssl
    unrar
    slack
    wireguard
    tailscale
    pulsemixer
  ];

  programs.mtr.enable = true;
  services.openssh.enable = true;

  networking.firewall.enable = false;
  system.stateVersion = "20.09";

  networking.wireguard.interfaces.akua =
    metadata.hosts."${config.networking.hostName}";

  cadey = {
    discord.enable = true;
    dwm.enable = true;
    gui.enable = true;
    git.email = "xe@tailscale.com";
    kde.enable = true;
    sway = {
      enable = true;
      i3status = true;
      output = {
        "DP-1" = {
          res = "2560x1440";
          pos = "1920,0";
          bg = "~/Pictures/Baphomet-wallpaper7.jpg.png fill";
        };
        "eDP-1" = {
          res = "1920x1080";
          pos = "0,360";
          bg = "~/Pictures/Baphomet-wallpaper7.jpg.png fill";
        };
      };
    };
  };

  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];

  boot.kernelPackages = pkgs.linuxPackages_5_10;

  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = false;
    # Compatibility shims, adjust according to your needs
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  security.sudo.wheelNeedsPassword = false;
}

