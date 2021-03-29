{
  network = {
    description = "Within's Cloud Hosting Fortress of Invincibility";
  };

  "kahless" = { config, pkgs, lib, ... }:
    let metadata = pkgs.callPackage ../metadata/peers.nix { };
    in {
      deployment.targetUser = "root";
      deployment.targetHost = metadata.raw.kahless.ip_addr;

      imports = [ ../../hosts/kahless/configuration.nix ];
    };

  "firgu" = { config, pkgs, lib, ... }:
    let metadata = pkgs.callPackage ../metadata/peers.nix { };
    in {
      deployment.targetUser = "root";
      deployment.targetHost = metadata.raw.firgu.ip_addr;

      imports = [ ../../hosts/firgu/configuration.nix ];
    };

  "lufta" = { config, pkgs, lib, ... }:
    let metadata = pkgs.callPackage ../metadata/peers.nix { };
    in {
      deployment.targetUser = "root";
      deployment.targetHost = metadata.raw.lufta.ip_addr;

      imports = [ ../../hosts/lufta/configuration.nix ];
    };
}
