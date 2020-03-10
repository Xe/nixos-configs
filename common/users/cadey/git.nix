{ config, lib, pkgs, ... }:

{
  programs.git = {
    package = pkgs.gitAndTools.gitFull;
    enable = true;
    userName = "Christine Dodrill";
    userEmail = "me@christine.website";
    ignores = [ ];
    extraConfig = {
      core.editor = "vim";
      credential.helper = "store --file ~/.git-credentials";
    };
  };
}
