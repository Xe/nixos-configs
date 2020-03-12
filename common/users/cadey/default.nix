{ config, pkgs, ... }:

{
  imports = [
    ./dev.nix
    ./dhall.nix
    ./fish
    ./git.nix
    ./k8s.nix
    ./keybase.nix
    ./media.nix
    ./nixops.nix
    ./pastebins
    ./spacemacs
    ./tmux.nix
  ];

  nixpkgs.config = {
    allowBroken = true;
    allowUnfree = true;
  };

  home.packages = with pkgs; [ neofetch vim htop ];
  programs.fish.enable = true;
  programs.home-manager.enable = true;
}
