{ config, pkgs, modulesPath, ... }: {
  imports =
    [ (modulesPath + "/profiles/qemu-guest.nix")
      <impermanence/nixos.nix>
    ];

  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "sr_mod" "virtio_blk" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/vda";

  users.users.root.initialPassword = "hunter2";

  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = [ "defaults" "size=2G" "mode=755" "noexec" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "ext4";
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-label/nix";
    autoResize = true;
    fsType = "ext4";
  };

  environment.persistence."/nix/persist" = {
    directories = [ "/var/log" "/srv" "/etc/nixos" ];
  };

  environment.etc."machine-id".source
    = "/nix/persist/etc/machine-id";
  environment.etc."ssh/ssh_host_rsa_key".source
    = "/nix/persist/etc/ssh/ssh_host_rsa_key";
  environment.etc."ssh/ssh_host_rsa_key.pub".source
    = "/nix/persist/etc/ssh/ssh_host_rsa_key.pub";
  environment.etc."ssh/ssh_host_ed25519_key".source
    = "/nix/persist/etc/ssh/ssh_host_ed25519_key";
  environment.etc."ssh/ssh_host_ed25519_key.pub".source
    = "/nix/persist/etc/ssh/ssh_host_ed25519_key.pub";

  security.auditd.enable = true;
  security.audit.enable = true;
  security.audit.rules = [
    "-a exit,always -F arch=b64 -S execve"
  ];

  fileSystems."/etc/nixos".options = [ "noexec" ];
  fileSystems."/srv".options = [ "noexec" ];
  fileSystems."/var/log".options = [ "noexec" ];

  boot.cleanTmpDir = true;
  boot.tmpOnTmpfs = true;
}
