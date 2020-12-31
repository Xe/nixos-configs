pkgs: {
  nur = import (builtins.fetchTarball
    "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };

  xe = import (builtins.fetchTarball
    "https://github.com/Xe/xepkgs/archive/master.tar.gz") { inherit pkgs; };

  within = {
    mi = import
      (builtins.fetchTarball "https://github.com/Xe/mi/archive/mara.tar.gz")
      { };
    pahi = import
      (builtins.fetchTarball "https://github.com/Xe/pahi/archive/main.tar.gz")
      { };
    tron = import (builtins.fetchTarball
      "https://tulpa.dev/cadey/tron/archive/master.tar.gz") { };
    withinbot = import (builtins.fetchTarball
      "https://github.com/Xe/withinbot/archive/main.tar.gz") { };

    aura = pkgs.callPackage ./aura {};
    rhea = pkgs.callPackage ./rhea {};
  };

  lagrange = pkgs.callPackage ./lagrange {};

  xxx.hack = { tailscale = pkgs.callPackage ../pkgs/tailscale.nix { }; };
}
