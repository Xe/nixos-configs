{ lib, config, pkgs, ... }:

with lib;

let cfg = config.xe.htop;
in {
  options.xe.htop.enable = mkEnableOption "htop";
  config = mkIf cfg.enable {
    programs.htop = {
      enable = true;
      hideKernelThreads = true;
      hideThreads = true;
      hideUserlandThreads = true;
      sortKey = "PERCENT_CPU";
      meters = {
        left = [ "LeftCPUs2" "Memory" "CPU" ];
        right = [ "RightCPUs2" "Tasks" "LoadAverage" "Uptime" ];
      };
    };
  };
}
