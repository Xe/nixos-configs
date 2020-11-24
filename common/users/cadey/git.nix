{ config, lib, pkgs, nixosConfig, ... }:

let
  commitTemplate = with nixosConfig.cadey.git;
    pkgs.writeTextFile {
      name = "cadey-commit-template";
      text = ''


        Signed-off-by: ${name} <${email}>
      '';
    };
in {
  programs.git = {
    package = pkgs.gitAndTools.gitFull;
    enable = true;
    userName = nixosConfig.cadey.git.name;
    userEmail = nixosConfig.cadey.git.email;
    ignores = [ "*~" "*.swp" "*.#" ];
    delta.enable = true;
    extraConfig = {
      commit.template = "${commitTemplate}";
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
