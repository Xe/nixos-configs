{ config, pkgs, ... }:

{
  imports = [ <home-manager/nixos> ];

  users.users.cadey = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "audio" "plugdev" "libvirtd" "adbusers" ];
    shell = pkgs.fish;
  };

  home-manager.users.cadey = (import ./cadey/core.nix);
}
