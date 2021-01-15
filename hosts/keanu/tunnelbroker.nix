{ config, lib, pkgs, ... }:

{
  networking.interfaces = {
    he-ipv6 = {
      ipv6 = {
        addresses = [{
          address = "2001:470:1c:4ee::2";
          prefixLength = 64;
        }];
        routes = [{
          address = "::";
          prefixLength = 0;
          via = "2001:470:1c:4ee::1";
        }];
      };
      mtu = 1480;
      virtual = true;
    };
    enp3s0f2.ipv6.addresses = [
      {
        address = "2001:470:1d:4ee::";
        prefixLength = 64;
      }
      {
        address = "2001:470:bb1b:1::";
        prefixLength = 64;
      }
    ];
  };
  networking.sits = {
    he-ipv6 = {
      dev = "enp3s0f2";
      remote = "216.66.38.58";
      local = "192.168.0.159";
      ttl = 255;
    };
  };

  services.corerad = {
    enable = true;
    settings = {
      interfaces = [{
        name = "enp3s0f2";
        advertise = true;
        prefix = [{ prefix = "::/64"; }];
      }];
      debug = {
        address = "10.77.2.1:38177";
        prometheus = true;
      };
    };
  };

  boot.kernel.sysctl = {
    "net.ipv4.forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };
}