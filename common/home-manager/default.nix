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
    ./weechat

    # implicit
    ./pastebins
  ];

  nixpkgs.config = {
    allowBroken = true;
    allowUnfree = true;

    overlays = [
      (import ../../pkgs/overlay.nix)
      (self: super: { stdenv.lib = super.lib; })
    ];

    manual.manpages.enable = true;
  };

  systemd.user.startServices = true;
}
