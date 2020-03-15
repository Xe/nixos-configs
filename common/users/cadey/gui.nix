{ config, pkgs, ... }:

{
  imports = [ ./keybase.nix ./media.nix ./obs.nix ./st ./xresources.nix ];
}
