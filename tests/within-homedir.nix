let pkgs = <nixpkgs>;
in import "${pkgs}/nixos/tests/make-test-python.nix" ({ pkgs, ... }: {
  system = "x86_64-linux";

  nodes.machine = { config, pkgs, ... }: {
    imports = [ ../common/base.nix ];
    virtualisation.graphics = false;
  };

  testScript = ''
    import time

    start_all()

    machine.wait_for_console_text("Finished Creates homedirs for /srv/within services.")
  '';
})
