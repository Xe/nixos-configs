{ config, pkgs, ... }:

{
  programs.emacs.enable = true;
  services.emacs.enable = true;

  home.file = {
    ".spacemacs".source = ./spacemacs;
  };

  home.file."bin/e" = {
    text = ''
      #!/bin/sh
      emacsclient -a "" -nc $@
    '';
    executable = true;
  };
}
