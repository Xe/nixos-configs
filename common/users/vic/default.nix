{ pkgs, ... }:

{
  imports = [ ../../home-manager ];

  xe.powershell.enable = true;

  home.packages = [ pkgs.vim ];

  programs.git = {
    enable = true;
    userName = "Victor Fernandes";
    userEmail = "victorvalenca@gmail.com";
    ignores = [ "*~" "*.swp" "*.#" ];
    delta.enable = true;
    extraConfig = {
      core.editor = "vim";
      credential.helper = "store --file ~/.git-credentials";
      format.signoff = true;
      init.defaultBranch = "main";
      protocol.keybase.allow = "always";
      pull.rebase = "true";

      url = {
        "git@github.com:".insteadOf = "https://github.com/";
        "git@ssh.tulpa.dev:".insteadOf = "https://tulpa.dev/";
      };
    };
  };
}
