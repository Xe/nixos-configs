{ config, lib, pkgs, ... }:

let
  fetchKeys = username:
    (builtins.fetchurl "https://github.com/${username}.keys");
in {
  imports = [
    #installer-only ./hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;

  networking.hostName = "install";
  networking.firewall.enable = false;

  users.users.root.openssh.authorizedKeys.keyFiles = [ (fetchKeys "Xe") ];

  services.openssh.enable = true;
  users.mutableUsers = false;

  environment.defaultPackages = lib.mkForce [ ];
  nix.allowedUsers = [ "root" ];
}
