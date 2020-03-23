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
    kdeApplications.ark
    kdeApplications.kate
    kdeApplications.spectacle
    kdeApplications.okular
    plasma-browser-integration
    wireguard
    killall
  ];

  cadey.gui.enable = true;
  cadey.dwm.enable = false;
  virtualisation.docker.enable = true;

  home-manager.users.cadey = (import ./users/cadey/gui.nix);
}
