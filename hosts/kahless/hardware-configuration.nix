# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "ehci_pci" "ahci" "xhci_pci" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "rpool/safe/root";
      fsType = "zfs";
    };

  fileSystems."/nix" =
    { device = "rpool/local/nix";
      fsType = "zfs";
    };

  fileSystems."/home" =
    { device = "rpool/safe/home";
      fsType = "zfs";
    };

  fileSystems."/srv" =
    { device = "rpool/safe/srv";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/40ab51d1-5f64-442c-9d4d-5d10037eabc8";
      fsType = "ext2";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/3fb46ede-9ac5-489c-a755-1ffcfebb1df7"; }
      { device = "/dev/disk/by-uuid/ec6245ec-97d6-4b5a-b3f5-43b067cc44f0"; }
    ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}