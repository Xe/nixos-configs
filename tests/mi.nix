let pkgs = <nixpkgs>;
in import "${pkgs}/nixos/tests/make-test-python.nix" ({ pkgs, ... }: {
  system = "x86_64-linux";

  nodes.machine = { config, pkgs, ... }: {
    imports = [ ../common/base.nix ];
    virtualisation.graphics = false;

    within.services.mi.enable = true;
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("mi.service")
    machine.wait_until_succeeds("curl http://127.0.0.1:9001/.within/botinfo")
  '';
})
