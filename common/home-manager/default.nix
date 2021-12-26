{ ... }:

{
  imports = [
    # explicit xe.*
    ./dwm
    ./emacs
    ./fish
    #./htop.nix
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
    ./weechat

    # implicit
    ./pastebins
  ];

  nixpkgs.config = {
    allowBroken = true;
    allowUnfree = true;

    packageOverrides = import ../../pkgs;

    overlays = [
      (self: super: { stdenv.lib = super.lib; })
    ];

    manual.manpages.enable = true;
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  systemd.user.startServices = true;
}
