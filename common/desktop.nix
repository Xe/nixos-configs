{ config, pkgs, ... }:

{
  imports = [
    <home-manager/nixos>
    ./yubikey.nix
    ./programs/etcher.nix
    ./programs/virtualbox.nix
  ];

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

  home-manager.users.cadey = (import ./users/cadey/gui.nix);
}
