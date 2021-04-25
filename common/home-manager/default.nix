{ ... }:

{
  imports = [
    # explicit xe.*
    ./luakit
    ./powershell
    ./emacs
    ./tmux.nix
    ./keybase.nix
    ./vim
    ./htop.nix
    ./neofetch.nix
    ./dwm
    ./urxvt.nix
    ./sway.nix

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
