{ config, pkgs, ... }:

{
  home.file = {
    "bin/clbin" = {
      source = ./clbin;
      executable = true;
    };

    "bin/ix" = {
      source = ./ix;
      executable = true;
    };

    "bin/sprunge" = {
      source = ./sprunge;
      executable = true;
    };
  };
}
