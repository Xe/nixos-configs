let pkgs = <nixpkgs>;
in import "${pkgs}/nixos/tests/make-test-python.nix" ({ pkgs, ... }: {
  system = "x86_64-linux";

  nodes.machine = { config, pkgs, ... }: {
    imports = [ ../common ];
    virtualisation.graphics = false;
    environment = {
      etc."shaman.wasm".source = "${pkgs.within.pahi}/wasm/shaman.wasm";
      systemPackages = with pkgs; [ within.pahi ];
    };
  };

  testScript = ''
    start_all()

    print(machine.succeed("pahi /etc/shaman.wasm"))
  '';
})
