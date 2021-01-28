{config, pkgs, ...}:

{
  imports = [
    ./emacs
    ./tmux.nix
  ];

  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
  };

  services.lorri.enable = true;
}
