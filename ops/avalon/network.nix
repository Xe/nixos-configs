{
  network = { description = "Avalon"; };

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
      networking.hostName = "kos-mos";
      networking.hostId = "472479d4";

      imports =
        [ ../../common/hardware/alrest ../../hosts/kos-mos/configuration.nix ];
    };

  "logos.alrest" = { config, pkgs, lib, ... }:
    let metadata = pkgs.callPackage ../metadata/peers.nix { };
    in {
      deployment.targetUser = "root";
      deployment.targetHost = metadata.raw.logos.ip_addr;
      networking.hostName = "logos";
      networking.hostId = "aeace675";

      imports =
        [ ../../common/hardware/alrest ../../hosts/logos/configuration.nix ];
    };

  "ontos.alrest" = { config, pkgs, lib, ... }:
    let metadata = pkgs.callPackage ../metadata/peers.nix { };
    in {
      deployment.targetUser = "root";
      deployment.targetHost = metadata.raw.ontos.ip_addr;
      networking.hostName = "ontos";
      networking.hostId = "07602ecc";

      imports =
        [ ../../common/hardware/alrest ../../hosts/ontos/configuration.nix ];
    };

  "pneuma.alrest" = { config, pkgs, lib, ... }:
    let metadata = pkgs.callPackage ../metadata/peers.nix { };
    in {
      deployment.targetUser = "root";
      deployment.targetHost = metadata.raw.pneuma.ip_addr;
      networking.hostName = "pneuma";
      networking.hostId = "34fbd94b";

      imports =
        [ ../../common/hardware/alrest ../../hosts/pneuma/configuration.nix ];
    };
}
