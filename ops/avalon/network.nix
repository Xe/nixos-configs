{
  network = {
    description = "Avalon";
  };

  "chrysalis" = { config, pkgs, lib, ... }:
    let metadata = pkgs.callPackage ../metadata/peers.nix { };
    in {
      deployment.targetUser = "root";
      deployment.targetHost = metadata.raw.chrysalis.ip_addr;

      imports = [ ../../hosts/chrysalis/configuration.nix ];
    };

  # alrest
  "kos-mos.alrest" = { config, pkgs, lib, ... }:
    let metadata = pkgs.callPackage ../metadata/peers.nix { };
    in {
      deployment.targetUser = "root";
      deployment.targetHost = metadata.raw.kos-mos.ip_addr;

      imports = [ ../../hosts/kos-mos/configuration.nix ];
    };

  # "logos.alrest" = { config, pkgs, lib, ... }:
  #   let metadata = pkgs.callPackage ../metadata/peers.nix { };
  #   in {
  #     deployment.targetUser = "root";
  #     deployment.targetHost = metadata.raw.logos.ip_addr;
  #
  #     imports = [ ../../hosts/logos/configuration.nix ];
  #   };
  #
  # "ontos.alrest" = { config, pkgs, lib, ... }:
  #   let metadata = pkgs.callPackage ../metadata/peers.nix { };
  #   in {
  #     deployment.targetUser = "root";
  #     deployment.targetHost = metadata.raw.ontos.ip_addr;
  #
  #     imports = [ ../../hosts/ontos/configuration.nix ];
  #   };
  #
  # "pneuma.alrest" = { config, pkgs, lib, ... }:
  #   let metadata = pkgs.callPackage ../metadata/peers.nix { };
  #   in {
  #     deployment.targetUser = "root";
  #     deployment.targetHost = metadata.raw.pneuma.ip_addr;
  #
  #     imports = [ ../../hosts/pneuma/configuration.nix ];
  #   };
}
