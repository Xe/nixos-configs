{ config, pkgs, ... }:
  
{
  users.motd = builtins.readFile ./motd;
}
