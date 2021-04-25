{ config, pkgs, ... }:

let
  nur-no-pkgs = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {};
in {
  imports = with nur-no-pkgs.repos.xe.modules; [
    ./dev.nix
    ./git.nix
    ./k8s.nix
    #./nixops.nix
    ./spacemacs
    ./fish
    ../../home-manager
  ];

  xe = {
    htop.enable = true;
    neofetch.enable = true;
    powershell.enable = true;
    tmux.enable = true;
    vim.enable = true;
  };

  programs.home-manager.enable = true;
}
