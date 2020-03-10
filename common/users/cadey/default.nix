{ config, pkgs, ... }:

{
  imports = [ ./dev.nix ./dhall.nix ./git.nix ./tmux.nix ];

  nixpkgs.config = {
    allowBroken = true;
    allowUnfree = true;
  };

  home.packages = with pkgs; [ neofetch vim htop ];
  programs.fish.enable = true;
  programs.home-manager.enable = true;
}
