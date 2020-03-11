{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # cluster management tool
    kubectl

    # Digital Ocean management tool
    doctl

    # dhall-yaml
    (import <dhall> { }).linux-dhall-yaml
  ];
}
