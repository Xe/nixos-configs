{ config, pkgs, ... }:

let
  extraImports = [
    ./keybase.nix
    ./media.nix
    ./urxvt.nix
    ./xresources.nix
  ];
in rec {
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
  ] ++ extraImports;

  nixpkgs.config = {
    allowBroken = true;
    allowUnfree = true;
  };

  home.packages = with pkgs; [ neofetch vim htop ];
  programs.fish.enable = true;
  programs.home-manager.enable = true;
}
