{ config, pkgs, ... }:

let
  metadata =
    pkgs.callPackage /home/cadey/code/nixos-configs/ops/metadata/peers.nix { };
in {
  imports = [
    ./hardware-configuration.nix
    /home/cadey/code/nixos-configs/common/users
    /home/cadey/code/nixos-configs/common/base.nix
    /home/cadey/code/nixos-configs/common/desktop.nix
    <home-manager/nixos>
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "genza"; # Define your hostname.
  networking.networkmanager.enable = true;
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

  services.xserver.libinput.enable = true;
  virtualisation.docker.enable = true;

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
  ];

  programs.mtr.enable = true;
  services.openssh.enable = true;

  networking.firewall.enable = false;
  system.stateVersion = "21.03";

  networking.wireguard.interfaces.akua =
    metadata.hosts."${config.networking.hostName}";
}

