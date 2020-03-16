{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ etcher ];
}
