{ config, pkgs, ... }:

{
  users.users.maisem = {
    isNormalUser = true;
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMm8WG2pzRbeTdNguEF9zmaj7bASf4YwXccAs5bVW14I"
    ];
  };
}
