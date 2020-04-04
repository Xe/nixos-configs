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

  programs.home-manager.enable = true;

  home.file.".config/nixpkgs/config.nix".text = ''
    {
      packageOverrides = pkgs: {
        nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
          inherit pkgs;
        };
      };
      allowUnfree = true;
    }
  '';
}
