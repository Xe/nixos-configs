{ config, lib, ... }: {
  options = {
    cadey.cpu = {
      enable = lib.mkEnableOption "Enables CPU Microcode updates";
      vendor = lib.mkOption { type = lib.types.enum [ "intel" "amd" ]; };
    };
  };

  config = lib.mkIf config.cadey.cpu.enable {
    hardware.cpu.intel.updateMicrocode = (config.cadey.cpu.vendor == "intel");
    hardware.cpu.amd.updateMicrocode = (config.cadey.cpu.vendor == "amd");
  };
}
