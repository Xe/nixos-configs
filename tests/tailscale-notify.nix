let
  nixpkgs = builtins.fetchTarball {
    url =
      "https://github.com/NixOS/nixpkgs/archive/58f9c4c7d3a42c912362ca68577162e38ea8edfb.tar.gz";

    sha256 = "1517dy07jf4zhzknqbgm617lgjxsn7a6k1vgq61c67f6h55qs5ij";
  };
in import "${nixpkgs}/nixos/tests/make-test-python.nix" ({ pkgs, ... }: {
  system = "x86_64-linux";

  nodes.machine = { config, pkgs, ... }: {
    imports = [ ../common/tailscale.nix ];

    nixpkgs.config.packageOverrides = pkgs: {
      xxx.hack.tailscale = pkgs.callPackage ../pkgs/tailscale.nix { };
    };

    cadey.tailscale = {
      enable = true;
      notifySupport = true;
      package = pkgs.xxx.hack.tailscale;

      autoprovision = {
        enable = true;
        key = builtins.readFile ./tailscale.secret;
      };
    };

    virtualisation.graphics = false;
  };

  testScript = ''
    import json
    import sys
    import time

    start_all()

    machine.wait_for_unit("tailscale.service")
    time.sleep(15)
    if "login successful" not in machine.succeed("systemctl status tailscale"):
        sys.exit(1)
  '';
})
