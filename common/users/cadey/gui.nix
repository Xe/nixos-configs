{ config, pkgs, ... }:

{
  imports = [ ./dwm ./keybase.nix ./media.nix ./obs.nix ./st ./xresources.nix ];
}
