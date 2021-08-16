{ config, pkgs, ... }:

{
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  virtualisation.docker.enable = true;
  users.motd = builtins.readFile ./motd;
}
