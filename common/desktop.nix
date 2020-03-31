{ config, pkgs, ... }:

{
  imports = [
    <home-manager/nixos>
    ./yubikey.nix
    ./programs/etcher.nix
    ./programs/virtualbox.nix
    ../packages/dwm
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
    plasma-browser-integration
    wireguard
    killall
    file
    gimp
    waifu2x-converter-cpp
  ];

  cadey.gui.enable = true;
  cadey.dwm.enable = true;
  virtualisation.docker.enable = true;

  home-manager.users.cadey = (import ./users/cadey/gui.nix);
}
