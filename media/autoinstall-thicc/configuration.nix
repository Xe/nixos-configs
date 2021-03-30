{ config, pkgs, ... }:

let
  fetchKeys = username:
    (builtins.fetchurl "https://github.com/${username}.keys");
in {
  imports = [
    #installer-only ./hardware-config.nix
    ../../common/base.nix
  ];

  nixpkgs.config.allowUnfree = true;

  networking.hostName = "install";
  networking.firewall.enable = false;

  services.openssh.enable = true;
  users.mutableUsers = false;
}
