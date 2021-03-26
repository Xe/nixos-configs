{
  network = {
    description = "Within's Cloud Hosting Fortress of Invincibility";
    deployment.targetUser = "root";
  };

  "kahless" = { config, pkgs, lib, ... }:
    let metadata = pkgs.callPackage ../metadata/peers.nix { };
    in {
      deployment.targetHost = metadata.raw.kahless.ip_addr;

      imports = [ ../../hosts/kahless/configuration.nix ];
    };
}
