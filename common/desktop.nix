{ config, pkgs, ... }:

{
  imports = [
    <home-manager/nixos>
    ./yubikey.nix
    ./programs/discord.nix
    ./programs/dwm.nix
    ./programs/etcher.nix
    ./programs/kde.nix
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
    element-desktop
    openssl
    unrar
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

  hardware.pulseaudio.extraConfig = ''
    .ifexists module-echo-cancel.so
    load-module module-echo-cancel aec_method=webrtc source_name=echocancel sink_name=echocancel1
    set-default-source echocancel
    set-default-sink echocancel1
    .endif
  '';
}
