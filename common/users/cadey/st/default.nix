{ config, pkgs, ... }:

let
  nur = import (builtins.fetchTarball
    "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  termDesktop = pkgs.writeTextFile {
    name = "cadey-st.desktop";
    destination = "/share/applications/cadey-st.desktop";
    text = ''
      [Desktop Entry]
      Exec=${nur.repos.xe.st}/bin/st
      Icon=utilities-terminal
      Name[en_US]=Cadey st
      Name=Cadey st
      StartupNotify=true
      Terminal=false
      Type=Application
    '';
  };

in { home.packages = [ termDesktop ]; }
