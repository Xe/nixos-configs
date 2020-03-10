{ config, pkgs, ... }:

{
  imports = [ <home-manager/nixos> ./git.nix ];

  users.users.cadey = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    shell = pkgs.fish;
  };

  home-manager.users.cadey = { pkgs, ... }: {
    home.packages = with pkgs; [ neofetch git vim nixfmt ];
    programs.fish.enable = true;
  };
}
