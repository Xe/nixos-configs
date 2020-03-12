{ config, pkgs, ... }:

{
  programs.htop = {
    enable = true;
    hideKernelThreads = true;
    hideThreads = true;
    hideUserlandThreads = true;
    sortKey = "PERCENT_CPU";
  };
}
