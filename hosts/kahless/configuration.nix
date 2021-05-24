# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
      ./hardware-configuration.nix
      ./akua.nix
      ./zrepl.nix

      ../../common
      ../../common/services
      ../../common/users/home-manager.nix
  ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.devices = [ "/dev/sda" "/dev/sdb" "/dev/sdc" ];
  boot.zfs.devNodes = "/dev/disk/by-partuuid";
  boot.kernelParams = [ "zfs.zfs_arc_max=1073741824" ];

  networking.hostName = "kahless"; # Define your hostname.
  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = false;
  networking.hostId = "54b78fcf";

  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPg9gYKVglnO2HQodSJt4z4mNrUSUiyJQ7b+J798bwD9 cadey@shachi"
  ];

  networking.usePredictableInterfaceNames = false;
  systemd.network = {
    enable = true;
    networks."eth0".extraConfig = ''
      [Match]
      Name = eth0
      [Network]
      Address = 2607:5300:0060:1ccf::/64
      Gateway = 2607:5300:0060:1cff:ff:ff:ff:ff
      Address = 198.27.67.207/24
      Gateway = 198.27.67.254
      [Route]
      Destination=2607:5300:0060:1cff:ff:ff:ff:ff
      Scope=link
    '';
  };

  boot.supportedFilesystems = [ "zfs" ];

  environment.systemPackages = with pkgs; [ wget vim zfs weechat ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot.enable = true;

  cadey.cpu = {
    enable = true;
    vendor = "intel";
  };

  services.tailscale.enable = true;
  virtualisation.libvirtd.enable = true;

  security.sudo.wheelNeedsPassword = false;
}

