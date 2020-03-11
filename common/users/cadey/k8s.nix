{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # cluster management tool
    kubectl
    kubectx
    k9s

    # Digital Ocean management tool
    doctl

    # dhall-yaml
    (import <dhall> { }).linux-dhall-yaml

    # kubernetes in docker
    kind
  ];
}
