{ lib, config, pkgs, ... }:

with lib;

let cfg = config.xe.k8s;
in {
  options.xe.k8s.enable = mkEnableOption "Kubernetes tools";
  config = mkIf cfg.enable {
  home.packages = with pkgs; [
    # cluster management tool
    kubectl
    kubectx
    k9s

    # kubernetes in docker
    kind
  ];
};}
