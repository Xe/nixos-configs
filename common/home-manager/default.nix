{ ... }:

{
  imports = [
    # explicit xe.*
    ./dwm
    ./emacs
    ./fish
    ./htop.nix
    ./k8s.nix
    ./keybase.nix
    ./luakit
    ./neofetch.nix
    ./powershell
    ./sway
    ./tmux.nix
    ./urxvt.nix
    ./vim
    ./zathura

    # implicit
    ./pastebins
  ];

  nixpkgs.config = {
    allowBroken = true;
    allowUnfree = true;

    packageOverrides = import ../../pkgs;

    manual.manpages.enable = true;
  };
}
