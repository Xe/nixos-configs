{ config, lib, pkgs, ... }:

{
  services.lorri.enable = true;
  home.packages = with pkgs; [
    cachix
    niv
    nixfmt
    mosh
    gist
    bind
    unzip
    drone-cli
    nur.repos.xe.pridecat
  ];

  programs.direnv.enable = true;
  programs.direnv.enableFishIntegration = true;
}
