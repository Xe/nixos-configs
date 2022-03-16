{ config, pkgs, ... }:

{
  users.motd = builtins.readFile ./motd;
  services.tailscale.port = 15429;

  services.code-server = {
    enable = true;
    user = "cadey";
    group = "users";
    extraGroups = [ "within" ];
    host = "0.0.0.0";
    auth = "none";
    extraPackages = with pkgs;
      [
        # rust
        rustc
        cargo
        rust-analyzer
        rustfmt

        # ts
        nodejs
        nodePackages.typescript
        nodePackages.typescript-language-server

        # go
        go
        gotools
        gopls

        # other
        direnv
        pkg-config
        sqlite
        coreutils
        ncurses
        git
        gcc
        gnumake
        openssh
        procps
      ] ++ config.home-manager.users.cadey.home.packages;
    extraEnvironment = {
      HOME = "/home/cadey";
    };
  };
}
