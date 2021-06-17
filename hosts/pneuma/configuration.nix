{ config, pkgs, ... }:
  
{
  virtualisation.docker.enable = true;
  users.motd = builtins.readFile ./motd;
}
