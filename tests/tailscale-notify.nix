import "${<nixpkgs>}/nixos/tests/make-test-python.nix" ({ pkgs, ... }: {
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
    import sys
    import time

    start_all()

    machine.wait_for_unit("tailscale.service")
    machine.wait_for_console_text("auth=machine-authorized")
    if "login successful" not in machine.wait_until_succeeds("systemctl status tailscale"):
        sys.exit(1)
  '';
})
