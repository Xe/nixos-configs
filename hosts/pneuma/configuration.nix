{ config, pkgs, ... }:

{
  imports = [ ./robotnix.nix ];
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  virtualisation.docker.enable = true;
  users.motd = builtins.readFile ./motd;
  services.tailscale.port = 15430;

  services.corerad = {
    enable = true;
    settings = {
      interfaces = [{
        name = "virbr0";
        advertise = true;
        prefix = [{ prefix = "fd69:420:e621:b57c::/64"; }];
      }];
      debug = {
        address = "10.77.2.23:38177";
        prometheus = true;
      };
    };
  };
}
