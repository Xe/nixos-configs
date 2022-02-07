{
  network = { description = "Avalon"; };

  "itsuki.alrest" = { config, pkgs, lib, ... }:
    let metadata = pkgs.callPackage ../metadata/peers.nix { };
    in {
      deployment.targetUser = "root";
      deployment.targetHost = metadata.raw.itsuki.ip_addr;
      within.backups.repo = "57196@usw-s007.rsync.net:itsuki";

      imports =
        [ ../../common ../../hosts/itsuki/configuration.nix ];
    };

  # alrest
  "kos-mos.alrest" = { config, pkgs, lib, ... }:
    let metadata = pkgs.callPackage ../metadata/peers.nix { };
    in {
      deployment.targetUser = "root";
      deployment.targetHost = metadata.raw.kos-mos.ip_addr;
      networking.hostName = "kos-mos";
      networking.hostId = "472479d4";
      within.backups.repo = "57196@usw-s007.rsync.net:kos-mos";

      imports =
        [ ../../common/hardware/alrest ../../hosts/kos-mos/configuration.nix ];
    };

  "ontos.alrest" = { config, pkgs, lib, ... }:
    let metadata = pkgs.callPackage ../metadata/peers.nix { };
    in {
      deployment.targetUser = "root";
      deployment.targetHost = metadata.raw.ontos.ip_addr;
      networking.hostName = "ontos";
      networking.hostId = "07602ecc";
      within.backups.repo = "57196@usw-s007.rsync.net:ontos";

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
      within.backups.repo = "57196@usw-s007.rsync.net:pneuma";

      imports =
        [ ../../common/hardware/alrest ../../hosts/pneuma/configuration.nix ];
    };
}
