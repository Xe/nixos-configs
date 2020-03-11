{ config, pkgs, ... }:

{
  imports = [ ./xeserv ];

  nixpkgs.config.allowUnfree = true;
  nix.autoOptimiseStore = true;
  nix.trustedUsers = [ "root" "cadey" ];

  # caches
  nix.binaryCaches = [ "https://cache.dhall-lang.org" "https://xe.cachix.org" ];

  nix.binaryCachePublicKeys = [
    "cache.dhall-lang.org:I9/H18WHd60olG5GsIjolp7CtepSgJmM2CsO813VTmM="
    "xe.cachix.org-1:kT/2G09KzMvQf64WrPBDcNWTKsA79h7+y2Fn2N7Xk2Y="
  ];
}
