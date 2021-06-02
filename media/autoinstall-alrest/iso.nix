{ config, pkgs, lib, ... }: {
  systemd.services.install = {
    description = "Bootstrap a NixOS installation";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" "polkit.service" ];
    path = [ "/run/current-system/sw/" ];
    script = with pkgs; ''
        echo 'journalctl -fb -n100 -uinstall' >>~nixos/.bash_history

        set -eux

        # partitioning
        parted -s /dev/nvme0n1 -- mklabel gpt
        parted -s /dev/nvme0n1 -- mkpart primary 512MiB -8GiB
        parted -s /dev/nvme0n1 -- mkpart primary linux-swap -8GiB 100%
        parted -s /dev/nvme0n1 -- mkpart ESP fat32 1MiB 512MiB
        parted -s /dev/nvme0n1 -- set 3 esp on
        sync

        # zfs
        zpool create -f -O xattr=sa -O acltype=posixacl -O compression=zstd -O atime=off rpool /dev/nvme0n1p1
        zfs create -o mountpoint=none rpool/local
        zfs create -o mountpoint=legacy rpool/local/nix
        zfs create -o mountpoint=none rpool/safe
        zfs create -o mountpoint=legacy rpool/safe/home
        zfs create -o mountpoint=legacy rpool/safe/root
        zfs create -o mountpoint=none rpool/safe/vms
        sync

        # swap
        mkswap /dev/nvme0n1p2
        swapon /dev/nvme0n1p2

        # ESP
        mkfs.vfat /dev/nvme0n1p3

        # mounting
        mount -t zfs rpool/safe/root /mnt
        mkdir /mnt/boot /mnt/etc /mnt/home /mnt/nix
        mount /dev/nvme0n1p3 /mnt/boot
        mount -t zfs rpool/safe/home /mnt/home
        mount -t zfs rpool/local/nix /mnt/nix

        install -D ${./configuration.nix} /mnt/etc/nixos/configuration.nix
        install -D ${./hardware-configuration.nix} /mnt/etc/nixos/hardware-configuration.nix

        sed -i -E 's/(\w*)#installer-only /\1/' /mnt/etc/nixos/*

        hostid="$(printf "00000000%x" "$(cksum /etc/machine-id | cut -d' ' -f1)" | tail -c8)"
        sed -i -E 's/babecafe/'$hostid'/' /mnt/etc/nixos/hardware-configuration.nix

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
