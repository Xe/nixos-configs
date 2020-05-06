{ pkgs, config, lib, ... }:
let
  nur-no-pkgs = import (builtins.fetchTarball
    "https://github.com/nix-community/NUR/archive/master.tar.gz") { };
in {

  imports = with nur-no-pkgs.repos.xe.modules; [ <home-manager/nixos> dwm ];

  networking.hostName = "ascendant";

  virtualisation.virtualbox.guest.enable = true;
  virtualisation.vmware.guest.enable = true;

  environment.systemPackages = with pkgs; [ wget vim hack-font ];

  services.xserver.enable = true;
  services.xserver.displayManager.defaultSession = "none+dwm";
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.lightdm.autoLogin.enable = true;
  services.xserver.displayManager.lightdm.autoLogin.user = "cadey";

  security.sudo.wheelNeedsPassword = false;

  system.activationScripts = {
    base-dirs = {
      text = ''
        mkdir -p /nix/var/nix/profiles/per-user/cadey
        nix-channel --add https://nixos.org/channels/nixos-20.03 nixpkgs
      '';
      deps = [ ];
    };
  };

  nixpkgs.config = {
    allowBroken = true;
    allowUnfree = true;

    packageOverrides = pkgs: {
      nur = import (builtins.fetchTarball
        "https://github.com/nix-community/NUR/archive/master.tar.gz") {
          inherit pkgs;
        };
    };
  };

  cadey.dwm.enable = true;

  users.users.cadey = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "audio" "plugdev" "libvirtd" "adbusers" ];
    shell = pkgs.fish;
  };

  home-manager.users.cadey = { config, pkgs, ... }: {
    imports = with nur-no-pkgs.repos.xe.modules; [
      neofetch
      htop
      fish
      tmux
      luakit
      zathura

      ../common/users/cadey/xresources.nix
      ../common/users/cadey/emacs
      ../common/users/cadey/pastebins
    ];

    home.packages = with pkgs; [ hack-font ];

    nixpkgs.config = {
      allowBroken = true;
      allowUnfree = true;

      packageOverrides = pkgs: {
        nur = import (builtins.fetchTarball
          "https://github.com/nix-community/NUR/archive/master.tar.gz") {
            inherit pkgs;
          };
      };
    };
  };
}
