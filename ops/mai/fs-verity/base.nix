{ lib, config, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.kernelPatches = [{
    name = "fs-verity";
    patch = null;
    extraConfig = ''
      FS_VERITY y
      FS_VERITY_BUILTIN_SIGNATURES y
    '';
  }];
  boot.kernel.sysctl."fs.verity.require_signatures" = 1;
  nixpkgs.overlays = [
    (self: super: {
      fsverity-utils = super.stdenv.mkDerivation {
        name = "fsverity-utils-latest";
        src = super.fetchgit
          (builtins.fromJSON (builtins.readFile ./fsverity-utils.json));
        buildInputs = with super; [ openssl ];
        builder = ./fsverity-utils-builder.sh;
      };
    })
  ];
  environment.systemPackages = with pkgs; [ fsverity-utils vim openssl keyutils ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    autoResize = true;
    fsType = "ext4";
  };

  boot.growPartition = true;
  boot.kernelParams = [ "console=ttyS0" ];
  boot.loader.grub.device = lib.mkDefault "/dev/vda";
  boot.loader.timeout = 0;

  boot.initrd.availableKernelModules =
    [ "ata_piix" "uhci_hcd" "virtio_pci" "sr_mod" "virtio_blk" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  users.users.mai = {
    isNormalUser = true;
    initialPassword = "hunter2";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPg9gYKVglnO2HQodSJt4z4mNrUSUiyJQ7b+J798bwD9"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPYr9hiLtDHgd6lZDgQMkJzvYeAXmePOrgFaWHAjJvNU"
    ];
  };

  users.users.root.openssh.authorizedKeys.keys =
    config.users.users.mai.openssh.authorizedKeys.keys;

  services.openssh.enable = true;

  security.sudo.wheelNeedsPassword = false;
  services.cloud-init = {
    enable = true;
    ext4.enable = true;
  };
}
