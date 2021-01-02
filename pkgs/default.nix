pkgs: rec {
  nur = import (builtins.fetchTarball
    "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };

  github.com = {
    goproxyio.goproxy = pkgs.callPackage ./github.com/goproxyio/goproxy { };
    oragono.oragono = pkgs.callPackage ./github.com/oragono/oragono { };
    PonyvilleFM.aura = pkgs.callPackage ./github.com/PonyvilleFM/aura { };
    Xe = {
      mi = pkgs.callPackage ./github.com/Xe/mi { };
      rhea = pkgs.callPackage ./github.com/Xe/rhea { };
      site = pkgs.callPackage ./github.com/Xe/site { };
    };
  };

  xe = import (builtins.fetchTarball
    "https://github.com/Xe/xepkgs/archive/master.tar.gz") { inherit pkgs; };

  within = {
    pahi = import
      (builtins.fetchTarball "https://github.com/Xe/pahi/archive/main.tar.gz")
      { };
    tron = import (builtins.fetchTarball
      "https://tulpa.dev/cadey/tron/archive/master.tar.gz") { };
    withinbot = import (builtins.fetchTarball
      "https://github.com/Xe/withinbot/archive/main.tar.gz") { };

    # transitional hacks
    aura = github.com.PonyvilleFM.aura;
    rhea = github.com.Xe.rhea;
    mi = github.com.Xe.mi;
  };

  tulpa.dev = { };

  lagrange = pkgs.callPackage ./lagrange { };

  xxx.hack = { tailscale = pkgs.callPackage ./tailscale.nix { }; };
}
