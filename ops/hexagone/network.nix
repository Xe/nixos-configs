{
  network = {
    description = "L'hexagone";
  };

  "chrysalis" = { config, pkgs, lib, ... }:
    let metadata = pkgs.callPackage ../metadata/peers.nix { };
    in {
      deployment.targetUser = "root";
      deployment.targetHost = metadata.raw.chrysalis.ip_addr;

      imports = [ ../../hosts/chrysalis/configuration.nix ];
    };

  "keanu" = { config, pkgs, lib, ... }:
    let metadata = pkgs.callPackage ../metadata/peers.nix { };
    in {
      deployment.targetUser = "root";
      deployment.targetHost = metadata.raw.keanu.ip_addr;

      imports = [ ../../hosts/keanu/configuration.nix ];
    };
}
