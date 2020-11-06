{ config, lib, pkgs, ... }:

with lib; {
  imports = [ ./xeserv ./wireguard ./microcode.nix ];

  options.cadey.gui.enable = mkEnableOption "Enables GUI programs";

  config = {
    boot.cleanTmpDir = true;

    nix = {
      autoOptimiseStore = true;

      binaryCaches = [ "https://xe.cachix.org" ];
      binaryCachePublicKeys = [
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
      manual.manpages.enable = false;
    };

    security.pam.loginLimits = [{
      domain = "*";
      type = "soft";
      item = "nofile";
      value = "unlimited";
    }];

    # console.useXkbConfig = true;
    # services.xserver = {
    #   layout = "us";
    #   xkbVariant = "colemak";
    #   xkbOptions = "caps:escape";
    # };
  };
}
