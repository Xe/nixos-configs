{ config, pkgs, ... }:

{
  imports = [ ./hacky_vscode.nix ];

  services.corerad = {
    enable = true;
    settings = {
      interfaces = [{
        name = "virbr0";
        advertise = true;
        prefix = [{ prefix = "fda2:d982:1da2:278a::/64"; }];
      }];
      debug = {
        address = "10.77.2.20:38177";
        prometheus = true;
      };
    };
  };
  
  users.motd = builtins.readFile ./motd;
  environment.systemPackages = with pkgs; [ nodejs-14_x ];

  # networking.interfaces."virbr0".ipv6.addresses = [{
  #   address = "fda2:d982:1da2:278a::";
  #   prefixLength = 64;
  # }];

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };
}
