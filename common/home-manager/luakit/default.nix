{ config, pkgs, lib, ... }:

with lib;

let cfg = config.xe.luakit;
in {
  options.xe.luakit.enable = mkEnableOption "enables luakit in userspace";

  config = mkIf cfg.enable {
    home = {
      packages = [ pkgs.luakit ];
      file = {
        ".local/share/luakit/newtab.html".source = ./start.html;
        ".config/luakit/theme-dark.lua".source = ./theme-dark.lua;
        ".config/luakit/userconf.lua".text = ''
          local settings = require "settings"
          settings.window.home_page = "luakit://newtab/"

          -- Load library of useful functions for luakit
          local lousy = require "lousy"

          lousy.theme.init(lousy.util.find_config("theme-dark.lua"))
          assert(lousy.theme.get(), "failed to load theme")
        '';
      };
    };
  };
}
