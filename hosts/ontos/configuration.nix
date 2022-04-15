{ config, pkgs, ... }:

{
  users.motd = builtins.readFile ./motd;
  services.tailscale.port = 15429;
}
