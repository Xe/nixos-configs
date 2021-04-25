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

    # implicit
    ./pastebins
  ];
}
