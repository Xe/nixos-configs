{ config, pkgs, ... }:

let
  nur-no-pkgs = import (builtins.fetchTarball
    "https://github.com/nix-community/NUR/archive/master.tar.gz") { };
in {
  imports = with nur-no-pkgs.repos.xe.modules; [
    ./front
    ./media.nix
    ./obs.nix
    ./st

    #zathura
  ];

  xe = {
    keybase.enable = true;
    keybase.gui = true;
    luakit.enable = true;
    urxvt.enable = true;
  };

  home.packages = with pkgs; [
    krita
    virtmanager
    github.com.nomad-software.meme
  ];

  home.file = {
    "bin/memegen" = {
      executable = true;
      text = with pkgs;
        let meme = github.com.nomad-software.meme;
        in ''
          #!/usr/bin/env bash

          ${xclip}/bin/xclip -selection clipboard -t image/png -i $(${meme}/bin/meme -i "$1" -t "$2")
        '';
    };

    "bin/shakememe" = {
      executable = true;
      text = with pkgs;
        let meme = github.com.nomad-software.meme;
        in ''
          #!/usr/bin/env bash

          ${xclip}/bin/xclip -selection clipboard -t image/gif -i $(${meme}/bin/meme -gif -shake -i "$1" -t "$2")
        '';
    };
  };
}
