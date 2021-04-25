let pkgs = <nixpkgs>;
in import "${pkgs}/nixos/tests/make-test-python.nix" ({ pkgs, ... }: {
  system = "x86_64-linux";

  nodes.machine = { config, pkgs, ... }: {
    imports = [ ../common ];
    virtualisation.graphics = false;

    users.users.within = {
      createHome = true;
      description = "Questions? Inquire Within";
      isSystemUser = true;
      group = "within";
      home = "/srv/within/within";
    };
  };

  testScript = ''
    import time

    start_all()

    machine.wait_for_console_text("Finished Creates homedirs for /srv/within services.")
    machine.succeed("su -s $(which bash) within -- -c 'ls'")
  '';
})
