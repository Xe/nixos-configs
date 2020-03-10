{ config, pkgs, ... }:

{
  imports = [ ./dev.nix ./git.nix ./tmux.nix ];

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [ neofetch vim htop ];
  programs.fish.enable = true;
  programs.home-manager.enable = true;
}
