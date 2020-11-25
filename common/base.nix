{ config, lib, pkgs, ... }:

with lib; {
  imports = [
    ./xeserv
    ./wireguard
    ./colemak.nix
    ./microcode.nix
    ./ssd.nix
    ./tailscale.nix
    ./users
  ];

  options.cadey = {
    gui.enable = mkEnableOption "Enables GUI programs";

    git = {
      name = mkOption rec {
        type = types.str;
        default = "Christine Dodrill";
        example = default;
        description = "Name to use with git commits";
      };
      email = mkOption rec {
        type = types.str;
        default = "me@christine.website";
        example = default;
        description = "Email to use with git commits";
      };
    };
  };

  config = {
    boot.cleanTmpDir = true;

    nix = {
      autoOptimiseStore = true;
      useSandbox = false;

      binaryCaches = [ "https://xe.cachix.org" ];
      binaryCachePublicKeys =
        [ "xe.cachix.org-1:kT/2G09KzMvQf64WrPBDcNWTKsA79h7+y2Fn2N7Xk2Y=" ];

      trustedUsers = [ "root" "cadey" ];
    };

    nixpkgs.config = {
      allowUnfree = true;
      packageOverrides = pkgs: {
        nur = import (builtins.fetchTarball
          "https://github.com/nix-community/NUR/archive/master.tar.gz") {
            inherit pkgs;
          };

        within = {
          mi = import (builtins.fetchTarball
            "https://github.com/Xe/mi/archive/mara.tar.gz") { };
          pahi = import (builtins.fetchTarball
            "https://github.com/Xe/pahi/archive/main.tar.gz") { };
          tron = import (builtins.fetchTarball
            "https://tulpa.dev/cadey/tron/archive/master.tar.gz") { };
          withinbot = import (builtins.fetchTarball
            "https://github.com/Xe/withinbot/archive/main.tar.gz") { };
        };

        xxx.hack = { tailscale = pkgs.callPackage ../pkgs/tailscale.nix { }; };
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
