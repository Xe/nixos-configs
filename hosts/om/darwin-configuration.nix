{ config, pkgs, ... }:

{
  imports = [
    <home-manager/nix-darwin>
  ];

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [ vim wget
    ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  environment.darwinConfig = "$HOME/Code/nixos-configs/hosts/om/darwin-configuration.nix";

  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  # programs.bash.enable = true;
  # programs.zsh.enable = true;
  programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # You should generally set this to the total number of logical cores in your system.
  # $ sysctl -n hw.ncpu
  nix.maxJobs = 1;
  nix.buildCores = 1;

  users.users.cadey = {
    shell = pkgs.fish;
  };

  launchd.user.agents = {
    "lorri" = {
      serviceConfig = {
        WorkingDirectory = (builtins.getEnv "HOME");
        EnvironmentVariables = { };
        KeepAlive = true;
        RunAtLoad = true;
        StandardOutPath = "/var/tmp/lorri.log";
        StandardErrorPath = "/var/tmp/lorri.log";
      };
      script = ''
        source ${config.system.build.setEnvironment}
        exec ${pkgs.lorri}/bin/lorri daemon
      '';
    };
  };

  home-manager.users.cadey = { config, pkgs, ... }:
    let
      nur-no-pkgs = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {};
    in {
      imports = with nur-no-pkgs.repos.xe.modules; [
        neofetch
        tmux
        fish

        /Users/cadey/Code/nixos-configs/common/users/cadey/k8s.nix
        /Users/cadey/Code/nixos-configs/common/users/cadey/vim
      ];

      programs.home-manager.enable = true;
      programs.direnv = {
        enable = true;
        enableFishIntegration = true;
      };

      home.packages = with pkgs; [
        cachix niv nixfmt mosh gist bind unzip drone-cli lorri
      ];

      nixpkgs.config = {
        allowBroken = true;
        allowUnfree = true;

        packageOverrides = pkgs: {
          nur = import (builtins.fetchTarball
            "https://github.com/nix-community/NUR/archive/master.tar.gz") {
              inherit pkgs;
            };
        };
      };
    };
}
