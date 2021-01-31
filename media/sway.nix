{ pkgs, config, lib, ... }:

{
  imports = [ <home-manager/nixos> ../common/base.nix ../common/desktop.nix ];

  cadey.sway.enable = true;

  virtualisation.virtualbox.guest.enable = true;
  virtualisation.vmware.guest.enable = true;

  environment.systemPackages = with pkgs; [ wget vim hack-font firefox ];

  security.sudo.wheelNeedsPassword = false;

  system.activationScripts = {
    base-dirs = {
      text = ''
        mkdir -p /nix/var/nix/profiles/per-user/cadey
        nix-channel --add https://nixos.org/channels/nixos-unstable nixos
      '';
      deps = [ ];
    };
  };

  services.xserver.enable = true;
  services.xserver.displayManager.defaultSession = "sway";
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.lightdm.autoLogin.enable = true;
  services.xserver.displayManager.lightdm.autoLogin.user = "cadey";
}
