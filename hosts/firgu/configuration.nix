{ config, lib, pkgs, ... }:

let metadata = pkgs.callPackage ../../ops/metadata/peers.nix { };
in {
  imports = [
    ../../common
    ../../common/services
    ../../common/users/home-manager.nix
    ./hardware-configuration.nix
    ./shellbox.nix
  ];

  services.openssh.enable = true;

  networking.useDHCP = false;
  networking.interfaces.ens3.useDHCP = true;
  networking.hostName = "firgu";
  networking.firewall.enable = false;

  i18n.defaultLocale = "en_US.UTF-8";

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/vda"; # or "nodev" for efi only

  environment.systemPackages = with pkgs; [
    wget
    vim
    python3
    lua5_2
    lua5_sec
    git
  ];

  system.stateVersion = "20.09"; # Did you read the comment?

  within.services.snoo2nebby.enable = true;

  boot.kernel.sysctl = {
    "net.ipv4.forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };
}
