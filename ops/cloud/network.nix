{
  network = {
    description = "Within's Cloud Hosting Fortress of Invincibility";
  };

  "firgu" = { config, pkgs, lib, ... }:
    let metadata = pkgs.callPackage ../metadata/peers.nix { };
    in {
      deployment.targetUser = "root";
      deployment.targetHost = metadata.raw.firgu.ip_addr;
      deployment.substituteOnDestination = true;

      imports = [ ../../hosts/firgu/configuration.nix ];
    };

  "lufta" = { config, pkgs, lib, ... }:
    let metadata = pkgs.callPackage ../metadata/peers.nix { };
    in {
      deployment.targetUser = "root";
      deployment.targetHost = metadata.raw.lufta.ip_addr;
      deployment.substituteOnDestination = true;

      imports = [ ../../hosts/lufta/configuration.nix ];
    };
}
