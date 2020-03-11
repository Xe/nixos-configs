{ config, pkgs, ... }:

{
  imports = [ ./dev.nix ./fish ./git.nix ./k8s.nix ./tmux.nix ./spacemacs ];

  nixpkgs.config = {
    allowBroken = true;
    allowUnfree = true;
  };

  home.packages = with pkgs; [ neofetch vim htop ];
  programs.fish.enable = true;
  programs.home-manager.enable = true;
}
