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
    ./services
    ./programs/dwm.nix
    ./programs/sway.nix
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

    environment.systemPackages = with pkgs; [ age minisign tmate ];

    nix = {
      autoOptimiseStore = true;
      useSandbox = true;

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
      overlays = [
        (import ../pkgs/overlay.nix)
        (self: super: { stdenv.lib = super.lib; })
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
        ${coreutils}/bin/mkdir -p /srv/within/run
        ${coreutils}/bin/chown root:within /srv/within/run
        ${coreutils}/bin/chmod 770 /srv/within/run
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
