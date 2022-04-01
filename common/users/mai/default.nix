{ config, pkgs, ... }:

{
  imports = [ ../../home-manager ];

  xe = {
    emacs.enable = true;
    fish.enable = true;
    tmux.enable = true;
    tmux.shortcut = "a";
    vim.enable = true;
  };

  #programs.direnv.enableFishIntegration = true;

  nixpkgs.config = {
    allowBroken = true;
    allowUnfree = true;

    packageOverrides = import ../../../pkgs;

    manual.manpages.enable = true;
  };

  services.lorri.enable = true;
}
