{ config, lib, pkgs, ... }:

with lib; {
  imports = [
    ./xeserv
    ./wireguard
    ./colemak.nix
    ./microcode.nix
    ./ssd.nix
    ./tailscale.nix
    ./rhea.nix
    ./users
    ./coredns
    ./crypto
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

    environment.systemPackages = with pkgs; [ age minisign ];

    nix = {
      autoOptimiseStore = true;
      useSandbox = false;

      binaryCaches =
        [ "https://xe.cachix.org" "https://nix-community.cachix.org" ];
      binaryCachePublicKeys = [
        "xe.cachix.org-1:kT/2G09KzMvQf64WrPBDcNWTKsA79h7+y2Fn2N7Xk2Y="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];

      trustedUsers = [ "root" "cadey" ];
    };

    nixpkgs.config = {
      allowUnfree = true;
      packageOverrides = import ../pkgs;
      overlays = [

      ];
    };

    security.pam.loginLimits = [{
      domain = "*";
      type = "soft";
      item = "nofile";
      value = "unlimited";
    }];

    users.groups.within = { };
    systemd.services.within-homedir-setup = {
      description = "Creates homedirs for /srv/within services";
      wantedBy = [ "multi-user.target" ];

      serviceConfig.Type = "oneshot";

      script = with pkgs; ''
        ${coreutils}/bin/mkdir -p /srv/within
        ${coreutils}/bin/chown root:within /srv/within
        ${coreutils}/bin/chmod 775 /srv/within
      '';
    };

    services.journald.extraConfig = ''
      SystemMaxUse=100M
      MaxFileSec=7day
    '';

    services.resolved = {
      enable = true;
      dnssec = "false";
    };
  };
}
