# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "uas" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/950b627b-473b-49a7-8547-30798b18e103";
      fsType = "ext4";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/154a36c6-097b-4443-a6ae-ee7e9b1e5fc6"; }
    ];

  nix.maxJobs = lib.mkDefault 12;
}
