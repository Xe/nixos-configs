pkgs: rec {
  nur = import (builtins.fetchTarball
    "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };

  github.com = {
    goproxyio.goproxy = pkgs.callPackage ./github.com/goproxyio/goproxy { };
    jroimartin.sw = pkgs.callPackage ./github.com/jroimartin/sw { };
    luakit.luakit = pkgs.callPackage ./github.com/luakit/luakit {
      inherit (pkgs.luajitPackages) luafilesystem luasocket;
    };
    nomad-software.meme = pkgs.callPackage ./github.com/nomad-software/meme { };
    oragono.oragono = pkgs.callPackage ./github.com/oragono/oragono { };
    PonyvilleFM.aura = pkgs.callPackage ./github.com/PonyvilleFM/aura { };
    Xe = {
      GraphvizOnline = pkgs.callPackage ./github.com/Xe/GraphvizOnline { };
      mi = pkgs.callPackage ./github.com/Xe/mi { };
      ircmon = pkgs.callPackage ./github.com/Xe/ircmon { };
      rhea = pkgs.callPackage ./github.com/Xe/rhea { };
      site = pkgs.callPackage ./github.com/Xe/site { };
      withinbot = pkgs.callPackage ./github.com/Xe/withinbot { };
    };
  };

  xe = import (builtins.fetchTarball
    "https://github.com/Xe/xepkgs/archive/master.tar.gz") { inherit pkgs; };

  tulpa.dev = {
    cadey = let sw = github.com.jroimartin.sw;
    in {
      aegis = pkgs.callPackage ./tulpa.dev/cadey/aegis { };
      cabytcini = pkgs.callPackage ./tulpa.dev/cadey/cabytcini { };
      hlang = pkgs.callPackage ./tulpa.dev/cadey/hlang { };
      lewa = pkgs.callPackage ./tulpa.dev/cadey/lewa { };
      nanpa = pkgs.callPackage ./tulpa.dev/cadey/nanpa { };
      printerfacts = pkgs.callPackage ./tulpa.dev/cadey/printerfacts { };
      snoo2nebby = pkgs.callPackage ./tulpa.dev/cadey/snoo2nebby { };
      todayinmarch2020 =
        pkgs.callPackage ./tulpa.dev/cadey/todayinmarch2020 { };
      tulpaforce =
        pkgs.callPackage ./tulpa.dev/cadey/tulpaforce { inherit sw; };
      tron = pkgs.callPackage ./tulpa.dev/cadey/tron { };
    };
    tulpa-ebooks.tulpanomicon =
      pkgs.callPackage ./tulpa.dev/tulpa-ebooks/tulpanomicon { };
    Xe.quickserv = pkgs.callPackage ./tulpa.dev/Xe/quickserv { };
  };

  within = {
    pahi = import
      (builtins.fetchTarball "https://github.com/Xe/pahi/archive/main.tar.gz")
      { };

    # transitional hacks
    aura = github.com.PonyvilleFM.aura;
    rhea = github.com.Xe.rhea;
    mi = github.com.Xe.mi;
    tron = tulpa.dev.cadey.tron;
    withinbot = github.com.Xe.withinbot;
  };

  x = {
    caddy = pkgs.callPackage ./x/caddy.nix { };
    idp = pkgs.callPackage ./x/idp.nix { };
    withinwebsite = pkgs.callPackage ./x/withinwebsite.nix { };
    johaus = pkgs.callPackage ./x/johaus.nix { };
  };

  xxx.hack = { tailscale = pkgs.callPackage ./tailscale.nix { }; };

  # hacks
  fish-foreign-env = pkgs.fishPlugins.foreign-env;
  luakit = github.com.luakit.luakit;

  weechat-matrix-fixed =
    pkgs.weechatScripts.weechat-matrix.overrideAttrs (oldAttrs: rec {
      postFixup = oldAttrs.postFixup + ''
        substituteInPlace $out/lib/*/site-packages/matrix/server.py --replace "\"matrix_sso_helper\"" "\"$out/bin/matrix_sso_helper\""
      '';
    });

  weechat = with pkgs.weechatScripts;
    pkgs.weechat.override {
      configure = { availablePlugins, ... }: {
        scripts = [ weechat-otr weechat-matrix-fixed wee-slack multiline ];
        extraBuildInputs =
          [ availablePlugins.python.withPackages (_: [ weechat-matrix ]) ];
      };
    };

  st = pkgs.callPackage ./st { };
}
