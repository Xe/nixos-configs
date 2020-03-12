{ config, lib, pkgs, ... }:

{
  services.lorri.enable = true;
  home.packages = with pkgs; [ cachix direnv niv nixfmt mosh gist ];

  programs.fish.interactiveShellInit = ''
    eval (${pkgs.direnv}/bin/direnv hook fish)
  '';
}
