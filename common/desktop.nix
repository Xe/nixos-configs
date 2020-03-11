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
  ];

  virtualisation.docker.enable = true;
}
