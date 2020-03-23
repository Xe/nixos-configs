{ config, pkgs, lib, ... }:

{
  services.plex = {
    dataDir = "/data/plex";
    user = "cadey";
    enable = true;
  };
}
