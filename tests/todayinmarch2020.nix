let pkgs = <nixpkgs>;
in import "${pkgs}/nixos/tests/make-test-python.nix" ({ pkgs, ... }: {
  system = "x86_64-linux";

  nodes.machine = { config, pkgs, ... }: {
    imports = [ ../common/base.nix ];
    virtualisation.graphics = false;

    within.services.todayinmarch2020.enable = true;
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("todayinmarch2020.service")
    print(
        machine.wait_until_succeeds(
            "curl --unix-socket /srv/within/run/todayinmarch2020.sock http://foo/"
        )
    )
  '';
})
