{ config, pkgs, ... }:

{
  imports = [
    ./front
    ./media.nix
    ./obs.nix
  ];

  xe = {
    keybase.enable = true;
    keybase.gui = true;
    luakit.enable = false;
    urxvt.enable = true;
  };

  home.packages = with pkgs; [
    krita
    virtmanager
    github.com.nomad-software.meme
  ];

  services.gnome-keyring.enable = true;

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
