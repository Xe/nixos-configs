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

        parted ''${dev} -- mklabel msdos

        parted ''${dev} -- mkpart primary ext4 1M 512M
        parted ''${dev} -- set 1 boot on
        parted ''${dev} -- mkpart primary ext4 512MiB 100%

        mkfs.ext4 -L boot ''${dev}1
        mkfs.ext4 -L nix ''${dev}2

        sync

        mount -t tmpfs none /mnt

        mkdir -p /mnt/{boot,nix,etc/{nixos,ssh},var/{lib,log},srv}

        mount ''${dev}1 /mnt/boot
        mount ''${dev}2 /mnt/nix

        mkdir -p /mnt/nix/persist/{etc/{nixos,ssh},var/{lib,log},srv}

        mount -o bind /mnt/nix/persist/etc/nixos /mnt/etc/nixos
        mount -o bind /mnt/nix/persist/var/log /mnt/var/log

        install -D ${./configuration.nix} /mnt/etc/nixos/configuration.nix
        install -D ${./hardware-configuration.nix} /mnt/etc/nixos/hardware-configuration.nix

        sed -i -E 's/(\w*)#installer-only /\1/' /mnt/etc/nixos/*

        nix-channel --add https://github.com/nix-community/impermanence/archive/refs/heads/master.tar.gz impermanence

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
