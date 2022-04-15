{
  network = {
    description = "Within's Cloud Hosting Fortress of Invincibility";
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
