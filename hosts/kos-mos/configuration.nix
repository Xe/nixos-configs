{ config, pkgs, ... }:

{
  imports = [ ./hacky_vscode.nix ./maisem.nix ];

  services.corerad = {
    enable = true;
    settings = {
      interfaces = [
        {
          name = "virbr0";
          advertise = false;
          prefix = [{ prefix = "fd69:420:e621:278a::/64"; }];
        }
        {
          name = "enp2s0";
          advertise = true;
          prefix = [{ prefix = "fd69:420:e621::/64"; }];
        }
      ];
      debug = {
        address = "10.77.2.20:38177";
        prometheus = true;
      };
    };
  };

  users.motd = builtins.readFile ./motd;
  environment.systemPackages = with pkgs; [ nodejs-14_x ];
  services.tailscale.port = 15428;

  # networking.interfaces."virbr0".ipv6.addresses = [{
  #   address = "fda2:d982:1da2:278a::";
  #   prefixLength = 64;
  # }];

  networking.interfaces."enp2s0".ipv6.addresses = [{
    address = "fd69:420:e621::fe34:97ff:fe0d:1ecd";
    prefixLength = 64;
  }];
}
