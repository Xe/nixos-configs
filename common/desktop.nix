{ config, pkgs, ... }:

{
  imports = [ <home-manager/nixos> ];

  environment.systemPackages = with pkgs; [
    discord
    slack
    tdesktop
    rambox
    firefox
    steam
    kdeApplications.spectacle
    plasma-browser-integration
    wireguard
    killall
  ];

  cadey.gui.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  users.extraGroups.vboxusers.members = [ "cadey" ];

  home-manager.users.cadey = (import ./users/cadey/gui.nix);
}
