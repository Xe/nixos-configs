{ config, pkgs, ... }:
  
{
  users.motd = builtins.readFile ./motd;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.availableKernelModules = [ "amdgpu" "vfio-pci" ];

  boot.kernelParams = [ "intel_iommu=on" "pcie_aspm=off" ];

  boot.initrd.preDeviceCommands = ''
    DEVS="0000:03:00.0 0000:03:00.1"
    for DEV in $DEVS; do
      echo "vfio-pci" > /sys/bus/pci/devices/$DEV/driver_override
    done
    modprobe -i vfio-pci
  '';
}
