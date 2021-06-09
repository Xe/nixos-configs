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
    ./programs/sway.nix
    ./users/home-manager.nix
  ];

  environment.systemPackages = with pkgs; [
    slack
    rambox
    firefox
    wireguard
    killall
    file
    gimp
    element-desktop
    openssl
    unrar
    steam-run-native
    st
  ];

  cadey = {
    discord.enable = true;
    dwm.enable = false;
    gui.enable = true;
    kde.enable = true;
    telegram.enable = true;
  };

  virtualisation.docker.enable = true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  home-manager.users.cadey = (import ./users/cadey/gui.nix);

  hardware.pulseaudio.extraConfig = ''
    .ifexists module-echo-cancel.so
    load-module module-echo-cancel aec_method=webrtc aec_args="analog_gain_control=0\ digital_gain_control=1" source_name=echocancel sink_name=echocancel1
    set-default-source echocancel
    set-default-sink echocancel1
    .endif
    load-module module-switch-on-connect
  '';

  programs.steam.enable = true;

  fonts.fonts = [
    (pkgs.runCommandLocal "zbalermorna-fonts" {
      src = pkgs.fetchFromGitHub {
        owner = "jackhumbert";
        repo = "zbalermorna";
        rev = "920b28d798ae1c06885c674bbf02b08ffed12b2f";
        sha256 = "sha256:00sl3f1x4frh166mq85lwl9v1f5r3ckkfg8id5fibafymick5vyp";
      };
    } ''
      mkdir --parents "$out/share/fonts/opentype"
      cp "$src/fonts"/*.otf "$out/share/fonts/opentype"
    '')
  ];
}
