{ lib, ... }:

let
  mirrors = {
    #"https://android.googlesource.com" = "/var/cache/robotnix/mirror";
    #"https://github.com/LineageOS" = "/var/cache/robotnix/lineageos/LineageOS";
  };
in {
  # systemd.services.nix-daemon.serviceConfig.Environment = [
  #   ("ROBOTNIX_GIT_MIRRORS=" + lib.concatStringsSep "|"
  #     (lib.mapAttrsToList (local: remote: "${local}=${remote}") mirrors))
  # ];

  # Also add local mirrors to nix sandbox exceptions
  nix.sandboxPaths = (lib.attrValues mirrors) ++ [ "/var/cache/ccache" ];
}
