{ config, pkgs, lib, ... }: {
  systemd.services.install = {
    description = "Bootstrap a NixOS installation";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" "polkit.service" ];
    path = [ "/run/current-system/sw/" ];
    script = with pkgs; ''
        echo 'journalctl -fb -n100 -uinstall' >>~nixos/.bash_history

        set -eux

        dev=/dev/vda

        ${utillinux}/bin/sfdisk --wipe=always $dev <<-END
          label: mbr

          name=NIXOS
        END
        mkfs.ext4 -L nixos ''${dev}1

        sync

        mount ''${dev}1 /mnt

        install -D ${./configuration.nix} /mnt/etc/nixos/configuration.nix
        install -D ${./hardware-configuration.nix} /mnt/etc/nixos/hardware-configuration.nix

        sed -i -E 's/(\w*)#installer-only /\1/' /mnt/etc/nixos/*

        ${config.system.build.nixos-install}/bin/nixos-install \
          --system ${
            (import <nixpkgs/nixos/lib/eval-config.nix> {
              system = "x86_64-linux";
              modules = [ ./configuration.nix ./hardware-configuration.nix ];
            }).config.system.build.toplevel
          } \
          --no-root-passwd \
          --cores 0

        echo 'Shutting off...'
        ${systemd}/bin/shutdown now
      '';
    environment = config.nix.envVars // {
      inherit (config.environment.sessionVariables) NIX_PATH;
      HOME = "/root";
    };
    serviceConfig = { Type = "oneshot"; };
  };
}
