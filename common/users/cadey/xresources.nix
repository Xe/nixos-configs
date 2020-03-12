{ config, pkgs, ... }:

let
  gruvbox = pkgs.fetchFromGitHub {
    owner = "morhetz";
    repo = "gruvbox-contrib";
    rev = "d7dea53e6e4f21993d7791dcac62fa4de6896c1e";
    sha256 = "127pj62f92gag111xg1i4rpk27078il7akza1av9ig8ad9xsiy4x";
  } + "/xresources/gruvbox-dark.xresources";
in { xresources.extraConfig = gruvbox; }
