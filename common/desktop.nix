{ config, pkgs, ... }:

{
  imports = [
    <home-manager/nixos>
    ./yubikey.nix
    ./programs/etcher.nix
    ./programs/virtualbox.nix
    ./programs/dwm.nix
  ];

  environment.systemPackages = with pkgs; [
    discord
    slack
    tdesktop
    rambox
    firefox
    steam
    latte-dock
    kdeApplications.ark
    kdeApplications.kate
    kdeApplications.spectacle
    kdeApplications.okular
    amarok
    plasma-browser-integration
    wireguard
    killall
    file
    gimp
    waifu2x-converter-cpp
    riot-desktop
    michabo
    openssl
    nur.repos.xe.st
  ];

  cadey.gui.enable = true;
  cadey.dwm.enable = true;
  virtualisation.docker.enable = true;

  home-manager.users.cadey = (import ./users/cadey/gui.nix);
}
