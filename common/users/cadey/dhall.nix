{ config, pkgs, ... }:

let dhall = import <dhall> { };
in {
  imports = [ ];
  home.packages = with dhall; [ linux-dhall linux-dhall-yaml linux-dhall-json linux-dhall-nix ];
}
