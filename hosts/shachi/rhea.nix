{ config, pkgs, ... }:

{
  cadey.rhea = {
    enable = false;
    sites = [
      rec {
        domain = "rhea.local.cetacean.club";
        certPath = "/home/cadey/code/Xe/rhea/var/${domain}/cert.pem";
        keyPath = "/home/cadey/code/Xe/rhea/var/${domain}/key.pem";
        files = {
          root = "/home/cadey/code/Xe/rhea/public/";
          autoIndex = true;
          userPaths = true;
        };
      }
      rec {
        domain = "cetacean.local.cetacean.club";
        certPath = "/home/cadey/code/Xe/rhea/var/${domain}/cert.pem";
        keyPath = "/home/cadey/code/Xe/rhea/var/${domain}/key.pem";
        reverseProxy = {
          domain = "cetacean.club";
          to = [ "cetacean.club:1965" ];
        };
      }
    ];
  };
}
