{ lib, config, nixosConfig, pkgs, ... }:

with lib;

let
  dquot = "''";
  cfg = config.xe.fish;
in {
  options.xe.fish.enable = mkEnableOption "fish config";

  config = mkIf cfg.enable {
    programs.fish.enable = true;

    home.file = {
      ".config/fish/functions/fish_greeting.fish".text = ''
        function fish_greeting;end
      '';

      ".config/fish/functions/fish_prompt.fish".source = ./fish_prompt.fish;
      ".config/fish/functions/fish_right_prompt.fish".source =
        ./fish_right_prompt.fish;
      ".config/fish/conf.d/ssh-agent.fish".source = ./ssh-agent.fish;

      # global fish config
      ".config/fish/conf.d/cadey.fish".text = ''
        alias edit "emacsclient -t -c -a ${dquot}"
        alias e "edit"

        set -gx GOPATH $HOME/go
        set -gx PATH $PATH $HOME/go/bin $HOME/bin

        set -gx GO111MODULE on

        set -gx PATH $PATH $HOME/.local/bin

        set -gx PATH $PATH $HOME/.luarocks/bin

        set -gx PATH $PATH $HOME/.cargo/bin

        set -gx WASMER_DIR $HOME/.wasmer
        set -gx WASMER_CACHE_DIR $WASMER_DIR/cache
        set -gx PATH $PATH $WASMER_DIR/bin $WASMER_DIR/globals/wapm_packages/.bin

        set -gx EDITOR vim
      '';

      ".config/fish/conf.d/colors.fish".text = ''
        switch $TERM
          case '*xte*'
            set -gx TERM xterm-256color
          case '*scree*'
            set -gx TERM screen-256color
          case '*rxvt*'
            set -gx TERM rxvt-unicode-256color
        end
      '';

      ".config/fish/conf.d/gpg.fish".text = ''
        # Set GPG TTY
        set -x GPG_TTY (tty)
      '';

      # ".config/fish/conf.d/zzz_yubikey.fish".text = if nixosConfig.cadey.gui.enable then ''
      #   set -gx SSH_AUTH_SOCK /run/user/(id -u)/yubikey-agent/yubikey-agent.sock
      # '' else "";
    };

    home.packages = [ pkgs.fishPlugins.foreign-env ];

    programs.fish.shellAliases = {
      pbcopy = "${pkgs.xclip}/bin/xclip -selection clipboard";
      pbpaste = "${pkgs.xclip}/bin/xclip -selection clipboard -o";
    };
  };
}
