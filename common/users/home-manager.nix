{config, pkgs, ...}:

{
  imports = [ <home-manager/nixos> ];

  home-manager.users.cadey = (import ./cadey/core.nix);
  home-manager.users.mai = (import ./mai);
  home-manager.users.vic = (import ./vic);
}
