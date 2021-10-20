# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  metadata =
    pkgs.callPackage /home/cadey/code/nixos-configs/ops/metadata/peers.nix { };
in {
  imports = [
    ./hardware-configuration.nix
    ./plex.nix
    ./smb.nix
    ./zrepl.nix

    ../../common/users/home-manager.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelParams = [ "nomodeset" ];

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;
  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /data 0.0.0.0/0(insecure,rw,sync,all_squash,anonuid=1000,anongid=996)
  '';
  security.sudo.wheelNeedsPassword = false;

  networking.hostName = "itsuki"; # Define your hostname.
  networking.hostId = "4d64f279";
  networking.useDHCP = false;
  networking.interfaces.enp2s0.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;
  services.openssh.enable = true;
  networking.firewall.enable = false;
  system.stateVersion = "21.05"; # Did you read the comment?

  environment.systemPackages = with pkgs; [ docker-compose ];

  services.tailscale.enable = true;

  # networking.wireguard.interfaces.akua =
  #   metadata.hosts."${config.networking.hostName}";

  services.nginx = {
    enable = true;
    virtualHosts."itsuki.shark-harmonic.ts.net" = {
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:32400";
        proxyWebsockets = true;
      };
      locations."/transmission" = {
        proxyPass = "http://127.0.0.1:9091";
        proxyWebsockets = true;
      };
      sslCertificate = "/srv/within/certs/itsuki.shark-harmonic.ts.net.crt";
      sslCertificateKey = "/srv/within/certs/itsuki.shark-harmonic.ts.net.key";
    };
  };
}
