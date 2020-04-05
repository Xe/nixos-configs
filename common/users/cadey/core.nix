{ config, pkgs, ... }:

{
  imports = [
    ./dev.nix
    ./dhall.nix
    ./fish
    ./git.nix
    ./htop.nix
    ./k8s.nix
    ./neofetch.nix
    ./nixops.nix
    ./pastebins
    ./spacemacs
    ./tmux.nix
  ];

  programs.home-manager.enable = true;

  nixpkgs.config = {
    allowBroken = true;
    allowUnfree = true;
  };
}
