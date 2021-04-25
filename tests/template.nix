let pkgs = <nixpkgs>;
in import "${pkgs}/nixos/tests/make-test-python.nix" ({ pkgs, ... }: {
  system = "x86_64-linux";

  nodes.machine = { config, pkgs, ... }: {
    imports = [ ../common ];
    virtualisation.graphics = false;
  };

  testScript = ''
    start_all()
  '';
})
