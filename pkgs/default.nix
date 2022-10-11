pkgs:
let sources = import ./nix/sources.nix;
in rec {
  nur = import sources.NUR { inherit pkgs; };

  # hacks
  pkgconfig = pkgs.pkg-config;
  virtmanager = pkgs.virt-manager;
  alsaLib = pkgs.alsa-lib;

  msedge = pkgs.callPackage ./msedge { };

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
      comicchat = pkgs.callPackage ./github.com/Xe/comicchat { };
      mi = pkgs.callPackage ./github.com/Xe/mi { };
      ircmon = pkgs.callPackage ./github.com/Xe/ircmon { };
      rhea = pkgs.callPackage ./github.com/Xe/rhea { };
      site = pkgs.callPackage ./github.com/Xe/site { };
      withinbot = pkgs.callPackage ./github.com/Xe/withinbot { };
    };
  };

  xe.discord = pkgs.callPackage ./discord { };

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

  weechat = with pkgs.weechatScripts;
    pkgs.weechat.override {
      configure = { availablePlugins, ... }: { scripts = [ multiline ]; };
    };

  #python39Packages.apsw = pkgs.callPackage ./hack/python-apsw.nix {};

  dwm = pkgs.callPackage ./dwm { };
  st = pkgs.callPackage ./st { };

  solanum = pkgs.solanum.overrideAttrs (old: rec {
    postPatch = ''
      substituteInPlace include/defaults.h --replace 'ETCPATH "' '"/etc/solanum'
    '';
  });
}
