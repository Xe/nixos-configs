{ config, pkgs, ... }:

{
  imports = [ ./emacs ./tmux.nix ];

  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
  };

  nixpkgs.config = {
    allowBroken = true;
    allowUnfree = true;

    packageOverrides = import ../../../pkgs;

    manual.manpages.enable = true;
  };

  services.lorri.enable = true;
}
