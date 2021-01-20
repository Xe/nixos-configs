{
  pa = { pkgs, ... }: {
    imports = [ ../../common/base.nix ../../common/generic-libvirtd.nix ];

    deployment.targetHost = "192.168.122.96";

    # create a service-specific user
    users.users.example.isSystemUser = true;

    # without this group the secret can't be read
    users.users.example.extraGroups = [ "keys" ];

    systemd.services.example = {
      wantedBy = [ "multi-user.target" ];
      after = [ "example-key.service" ];
      wants = [ "example-key.service" ];

      serviceConfig.User = "example";
      serviceConfig.Type = "oneshot";

      script = ''
        stat /run/keys/example
      '';
    };
    deployment.keys.example = {
      text = "this is a super sekrit value :)";
      user = "example";
      group = "keys";
      permissions = "0400";
    };
  };
}
