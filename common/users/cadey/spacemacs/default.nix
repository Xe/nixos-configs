{ config, pkgs, ... }:

let e = pkgs.writeTextFile {
      name = "cadey-emacs.desktop";
      destination = "/share/applications/cadey-emacs.desktop";
      text = ''
[Desktop Entry]
Exec=emacsclient -nc
Icon=emacs
Name[en_US]=Emacs Client
Name=Emacs Client
StartupNotify=true
Terminal=false
Type=Application
      '';
    };
in
{
  home.packages = with pkgs; [ anonymousPro e ];

  programs.emacs.enable = true;
  #programs.emacs.package = pkgs.emacsNativeComp;
  services.emacs.enable = true;
  #services.emacs.package = pkgs.emacsNativeComp;

  home.file.".spacemacs".source = ./spacemacs;

  home.file."bin/e" = {
    text = ''
      #!/bin/sh
      emacsclient -a "" -nc $@
    '';
    executable = true;
  };
}
