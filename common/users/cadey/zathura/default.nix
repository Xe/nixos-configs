{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [ zathura ];

    file.".config/zathura/zathurarc".source = ./zathurarc;
  };
}
