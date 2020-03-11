{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    discord
    slack
    tdesktop
    rambox
    firefox
    steam
    kdeApplications.spectacle
    wireguard
  ];

  virtualisation.docker.enable = true;
}
