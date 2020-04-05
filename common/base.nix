{ config, lib, pkgs, ... }:

with lib;
{
  imports = [ ./xeserv ./wireguard ];

  options.cadey.gui.enable = mkEnableOption "Enables GUI programs";

  config.nixpkgs.config.allowUnfree = true;
  config.nix.autoOptimiseStore = true;
  config.nix.trustedUsers = [ "root" "cadey" ];

  # caches
  config.nix.binaryCaches = [ "https://cache.dhall-lang.org" "https://xe.cachix.org" ];

  config.nix.binaryCachePublicKeys = [
    "cache.dhall-lang.org:I9/H18WHd60olG5GsIjolp7CtepSgJmM2CsO813VTmM="
    "xe.cachix.org-1:kT/2G09KzMvQf64WrPBDcNWTKsA79h7+y2Fn2N7Xk2Y="
  ];

  config.boot.cleanTmpDir = true;

  config.security.pam.loginLimits = [{
    domain = "*";
    type = "soft";
    item = "nofile";
    value = "unlimited";
  }];

  config.nixpkgs.config.packageOverrides = pkgs: {
    nur = import <nur> {
      inherit pkgs;
    };
  };
}
