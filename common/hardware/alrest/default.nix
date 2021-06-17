{ config, pkgs, ... }:

let metadata = pkgs.callPackage ../../../ops/metadata/peers.nix { };
in {
  imports = [
    ./hardware-configuration.nix
    ./monitoring.nix
    ./solanum.nix
    ./zrepl.nix

    ../..
    ../../services
    ../../users/home-manager.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.devNodes = "/dev/disk/by-partuuid";
  boot.kernelParams = [ "zfs.zfs_arc_max=1073741824" ];

  networking.interfaces.enp2s0.useDHCP = true;

  nixpkgs.config.allowUnfree = true;

  networking.firewall.enable = false;

  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [ wget vim zfs ];

  networking.wireguard.interfaces.akua =
    metadata.hosts."${config.networking.hostName}";

  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot.enable = true;

  cadey.cpu = {
    enable = true;
    vendor = "intel";
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  security.sudo.wheelNeedsPassword = false;

  services.tailscale.enable = true;
  virtualisation.libvirtd.enable = true;
}
