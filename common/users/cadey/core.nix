{ config, pkgs, ... }:

{
  imports = [
    ./dev.nix
    ./dhall.nix
    ./fish
    ./git.nix
    ./htop.nix
    ./k8s.nix
    ./nixops.nix
    ./pastebins
    ./spacemacs
    ./tmux.nix
  ];

  nixpkgs.config = {
    allowBroken = true;
    allowUnfree = true;
  };

  programs.home-manager.enable = true;
}
