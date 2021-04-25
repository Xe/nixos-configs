{ config, pkgs, ... }:

{
  imports = [
    ./dev.nix
    ./git.nix
    ./spacemacs
    ../../home-manager
  ];

  xe = {
    fish.enable = true;
    htop.enable = true;
    neofetch.enable = true;
    powershell.enable = true;
    tmux.enable = true;
    vim.enable = true;
  };

  programs.home-manager.enable = true;
}
