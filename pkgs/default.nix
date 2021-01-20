pkgs: rec {
  nur = import (builtins.fetchTarball
    "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };

  github.com = {
    goproxyio.goproxy = pkgs.callPackage ./github.com/goproxyio/goproxy { };
    jroimartin.sw = pkgs.callPackage ./github.com/jroimartin/sw { };
    oragono.oragono = pkgs.callPackage ./github.com/oragono/oragono { };
    PonyvilleFM.aura = pkgs.callPackage ./github.com/PonyvilleFM/aura { };
    Xe = {
      GraphvizOnline = pkgs.callPackage ./github.com/Xe/GraphvizOnline { };
      mi = pkgs.callPackage ./github.com/Xe/mi { };
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
      cabytcini = pkgs.callPackage ./tulpa.dev/cadey/cabytcini { };
      lewa = pkgs.callPackage ./tulpa.dev/cadey/lewa { };
      hlang = pkgs.callPackage ./tulpa.dev/cadey/hlang { };
      printerfacts = pkgs.callPackage ./tulpa.dev/cadey/printerfacts { };
      tulpaforce = pkgs.callPackage ./tulpa.dev/cadey/tulpaforce { inherit sw; };
      tron = pkgs.callPackage ./tulpa.dev/cadey/tron { };
    };
    tulpa-ebooks.tulpanomicon = pkgs.callPackage ./tulpa.dev/tulpa-ebooks/tulpanomicon { };
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

  lagrange = pkgs.callPackage ./lagrange { };

  x = {
    caddy = pkgs.callPackage ./x/caddy.nix { };
    idp = pkgs.callPackage ./x/idp.nix { };
    withinwebsite = pkgs.callPackage ./x/withinwebsite.nix { };
    johaus = pkgs.callPackage ./x/johaus.nix { };
  };

  xxx.hack = { tailscale = pkgs.callPackage ./tailscale.nix { }; };

  fish-foreign-env = pkgs.fishPlugins.foreign-env;
}
