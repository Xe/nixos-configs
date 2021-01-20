{ pkgs, config, lib, ... }:

with lib;

let
  cfg = config.within.secrets;

  secret = types.submodule {
    options = {
      name = mkOption {
        type = types.str;
        description = "human-readable name";
      };

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

  mkSecretOnDisk = { name, source, ... }:
    pkgs.stdenv.mkDerivation {
      name = "${name}-secret";
      phases = "installPhase";
      buildInputs = [ pkgs.age ];
      installPhase =
        let key = metadata.hosts."${config.networking.hostName}".ssh_pubkey;
        in ''
          age -a -r "${key}" -o $out
        '';
    };

  mkService = { name, source, dest, owner, group, permissions, ... }: {
    "${name}-key" = {
      description = "decrypt secret for ${name}";
      wantedBy = [ "multi-user.target" ];

      serviceConfig.Type = "oneshot";

      script = with pkgs; ''
        rm -rf ${dest}
        ${age}/bin/age -d -i /etc/ssh/ssh_host_ed25519_key -o ${dest} ${
          mkSecretOnDisk { inherit name source; }
        }

        chown ${owner}:${group} ${dest}
        chmod ${permissions} ${dest}
      '';
    };
  };
in {
  options.within.secrets = mkOption {
    type = types.listOf secret;
    description = "secret configuration";
    default = [ ];
  };

  config.systemd.services = (foldAttrs (n: a: recursiveUpdate a n) {} (forEach cfg mkService));
}
