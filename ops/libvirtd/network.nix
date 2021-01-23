let hosts = builtins.fromJSON (builtins.readFile ./wireguard/hosts.json);
in {
  network = {
    description = "simple hosts";
    deployment.targetUser = "root";
  };

  "pa" = { config, pkgs, lib, ... }: {
    imports =
      [ ../../common/generic-libvirtd.nix ./wireguard ];
    networking.firewall.enable = false;
    deployment.targetHost = "192.168.122.153";

    services.cockroachdb = {
      enable = true;
      locality = "country=ca,province=qc,region=hexagone,vm-host=shachi";
      join = "192.168.122.153:26257,192.168.122.175:26257,192.168.122.147:26257";
      insecure = true;
      http.address = "0.0.0.0";
      listen.address = config.deployment.targetHost;
    };
  };

  "re" = { config, pkgs, lib, ... }: {
    imports =
      [ ../../common/generic-libvirtd.nix ./wireguard ];
    networking.firewall.enable = false;
    deployment.targetHost = "192.168.122.175";

    services.cockroachdb = {
      enable = true;
      locality = "country=ca,province=qc,region=hexagone,vm-host=shachi";
      join = "192.168.122.153:26257,192.168.122.175:26257,192.168.122.147:26257";
      insecure = true;
      http.address = "0.0.0.0";
      listen.address = config.deployment.targetHost;
    };
  };

  "ci" = { config, pkgs, ... }: {
    imports = [ ../../common/generic-libvirtd.nix ./wireguard ];
    networking.firewall.enable = false;
    deployment.targetHost = "192.168.122.147";

    services.cockroachdb = {
      enable = true;
      locality = "country=ca,province=qc,region=hexagone,vm-host=shachi";
      join = "192.168.122.153:26257,192.168.122.175:26257,192.168.122.147:26257";
      insecure = true;
      http.address = "0.0.0.0";
      listen.address = config.deployment.targetHost;
    };
  };
}
