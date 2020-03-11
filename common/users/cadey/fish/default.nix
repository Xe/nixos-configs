{ config, pkgs, ... }:

let dquot = "''";
in {
  home.packages = with pkgs; [ fish ];

  home.file = {
    ".config/fish/functions/fish_greeting.fish".text = ''
      function fish_greeting;end
    '';

    ".config/fish/functions/fish_prompt.fish".source = ./fish_prompt.fish;
    ".config/fish/functions/fish_right_prompt.fish".source =
      ./fish_right_prompt.fish;
    ".config/fish/fish_variables".source = ./fish_variables;

    # global fish config
    ".config/fish/conf.d/cadey.fish".text = ''
      alias edit "emacsclient -t -c -a ${dquot}"
      alias e "edit"

      set -gx GOPATH $HOME/go
      set -gx PATH $PATH $HOME/go/bin $HOME/bin

      set -gx GO111MODULE on
      set -gx GOPROXY https://cache.greedo.xeserv.us

      set -gx PATH $PATH /home/cadey/.local/bin

      set -gx PATH $PATH $HOME/.luarocks/bin

      set -gx PATH $PATH $HOME/.cargo/bin

      set -gx WASMER_DIR /Users/within/.wasmer
      set -gx WASMER_CACHE_DIR $WASMER_DIR/cache
      set -gx PATH $PATH $WASMER_DIR/bin $WASMER_DIR/globals/wapm_packages/.bin
    '';
  };
}
