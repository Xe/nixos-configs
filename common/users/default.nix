{ config, pkgs, ... }:

{
  imports = [ <home-manager/nixos> ];

  users.users.cadey = {
    isNormalUser = true;
    extraGroups =
      [ "wheel" "docker" "audio" "plugdev" "libvirtd" "adbusers" "dialout" ];
    shell = pkgs.fish;
  };

  home-manager.users.cadey = (import ./cadey/core.nix);
}
