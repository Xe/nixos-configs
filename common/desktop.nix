{ config, pkgs, ... }:

{
  imports = [
    <home-manager/nixos>
    ./yubikey.nix
    ./programs/discord.nix
    ./programs/dwm.nix
    ./programs/etcher.nix
    ./programs/kde.nix
    ./programs/virtualbox.nix
    ./programs/telegram.nix
  ];

  environment.systemPackages = with pkgs; [
    slack
    rambox
    firefox
    steam
    wireguard
    killall
    file
    gimp
    waifu2x-converter-cpp
    riot-desktop
    michabo
    openssl
  ];

  cadey = {
    discord.enable = true;
    dwm.enable = true;
    gui.enable = true;
    kde.enable = true;
    telegram.enable = true;
  };

  virtualisation.docker.enable = true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  home-manager.users.cadey = (import ./users/cadey/gui.nix);
}
