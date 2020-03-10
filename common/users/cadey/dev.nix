{ config, lib, pkgs, ... }: {
  services.lorri.enable = true;
  home.packages = with pkgs; [ cachix direnv niv nixfmt ];

  programs.fish.interactiveShellInit = ''
    eval (${pkgs.direnv}/bin/direnv hook fish)
  '';
}
