{ config, lib, pkgs, ... }:

with lib; {
  imports = [ ./xeserv ./wireguard ];

  options.cadey.gui.enable = mkEnableOption "Enables GUI programs";

  config = {
    boot.cleanTmpDir = true;

    nix = {
      autoOptimiseStore = true;

      binaryCaches = [ "https://cache.dhall-lang.org" "https://xe.cachix.org" ];
      binaryCachePublicKeys = [
        "cache.dhall-lang.org:I9/H18WHd60olG5GsIjolp7CtepSgJmM2CsO813VTmM="
        "xe.cachix.org-1:kT/2G09KzMvQf64WrPBDcNWTKsA79h7+y2Fn2N7Xk2Y="
      ];

      trustedUsers = [ "root" "cadey" ];
    };

    nixpkgs.config = {
      allowUnfree = true;
      packageOverrides = pkgs: {
        nur = import (builtins.fetchTarball
          "https://github.com/nix-community/NUR/archive/master.tar.gz") {
            inherit pkgs;
          };
      };
    };

    security.pam.loginLimits = [{
      domain = "*";
      type = "soft";
      item = "nofile";
      value = "unlimited";
    }];
  };
}
