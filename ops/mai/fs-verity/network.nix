{
  network = {
    description = "simple hosts";
  };

  "rq" = { config, pkgs, lib, ... }: {
    imports = [ ./base.nix ];
    deployment.targetHost = "10.77.131.137";
    deployment.targetUser = "root";
  };
}
