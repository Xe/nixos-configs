{ config, pkgs, ... }:

{
  programs.htop = {
    enable = true;
    hideKernelThreads = true;
    hideThreads = true;
    hideUserlandThreads = true;
    sortKey = "PERCENT_CPU";
    meters = {
      left = [
        "LeftCPUs2"
        "Memory"
        "CPU"
      ];
      right = [
        "RightCPUs2"
        "Tasks"
        "LoadAverage"
        "Uptime"
      ];
    };
  };
}
