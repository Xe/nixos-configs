{ config, lib, pkgs, ... }:

{
  programs.git = {
    package = pkgs.gitAndTools.gitFull;
    enable = true;
    userName = "Christine Dodrill";
    userEmail = "me@christine.website";
    ignores = [ "*~" "*.swp" "*#" ];
    delta.enable = true;
    extraConfig = {
      core.editor = "vim";
      credential.helper = "store --file ~/.git-credentials";
      protocol.keybase.allow = "always";
      init.defaultBranch = "main";

      url = {
        "git@github.com:".insteadOf = "https://github.com/";
        "git@ssh.tulpa.dev:".insteadOf = "https://tulpa.dev/";
      };
    };
  };
}
