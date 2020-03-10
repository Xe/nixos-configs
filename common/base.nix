{ config, pkgs, ...}:

{
  nixpkgs.config.allowUnfree = true;
  nix.trustedUsers = [ "root" "cadey" ];
}
