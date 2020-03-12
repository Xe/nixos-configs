{ config, pkgs, ... }:

{
  imports = [
    ./dev.nix
    ./dhall.nix
    ./fish
    ./git.nix
    ./htop.nix
    ./k8s.nix
    ./keybase.nix
    ./media.nix
    ./nixops.nix
    ./pastebins
    ./spacemacs
    ./tmux.nix
    ./xresources.nix
  ];

  nixpkgs.config = {
    allowBroken = true;
    allowUnfree = true;
  };

  home.packages = with pkgs; [ neofetch vim htop ];
  programs.fish.enable = true;
  programs.home-manager.enable = true;
}
