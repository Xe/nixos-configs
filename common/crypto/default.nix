{ pkgs, config, lib, ... }:

with lib;

let
  cfg = config.within.secrets;

  secret = types.submodule {
    options = {
      source = mkOption {
        type = types.path;
        description = "local secret path";
      };

      dest = mkOption {
        type = types.str;
        description = "where to write the decrypted secret to";
      };

      owner = mkOption {
        default = "root";
        type = types.str;
        description = "who should own the secret";
      };

      group = mkOption {
        default = "root";
        type = types.str;
        description = "what group should own the secret";
      };

      permissions = mkOption {
        default = "0400";
        type = types.str;
        description = "Permissions expressed as octal.";
      };
    };
  };

  metadata = lib.importTOML ../../ops/metadata/hosts.toml;

  mkSecretOnDisk = name:
    { source, ... }:
    pkgs.stdenv.mkDerivation {
      name = "${name}-secret";
      phases = "installPhase";
      buildInputs = [ pkgs.rage ];
      installPhase =
        let key = metadata.hosts."${config.networking.hostName}".ssh_pubkey;
        in ''
          rage -a -r '${key}' -o "$out" '${source}'
        '';
    };

  mkService = name:
    { source, dest, owner, group, permissions, ... }: {
      description = "decrypt secret for ${name}";
      wantedBy = [ "multi-user.target" ];

      serviceConfig.Type = "oneshot";

      script = with pkgs; ''
        rm -rf ${dest}
        "${rage}"/bin/rage -d -i /etc/ssh/ssh_host_ed25519_key -o '${dest}' '${
          mkSecretOnDisk name { inherit source; }
        }'

        chown '${owner}':'${group}' '${dest}'
        chmod '${permissions}' '${dest}'
      '';
    };
in {
  options.within.secrets = mkOption {
    type = types.attrsOf secret;
    description = "secret configuration";
    default = { };
  };

  config.systemd.services = let
    units = mapAttrs' (name: info: {
      name = "${name}-key";
      value = (mkService name info);
    }) cfg;
  in units;
}
