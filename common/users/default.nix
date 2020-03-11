{ config, pkgs, ... }:

{
  imports = [ <home-manager/nixos> ];

  users.users.cadey = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "audio" "plugdev" "libvirtd" ];
    shell = pkgs.fish;
  };

  home-manager.users.cadey = (import ./cadey/default.nix);
}
