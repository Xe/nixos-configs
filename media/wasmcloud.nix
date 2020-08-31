{ pkgs, config, ... }:

let
  pahi = import (builtins.fetchTarball "https://github.com/Xe/pahi/archive/master.tar.gz") { };
in {
  boot.loader.grub.enable = false;

  # fileSystems = {
  #   "/" = {
  #     device = "/dev/vda";
  #     fsType = "ext4";
  #   };
  # };

  networking.hostName = "femto";

  environment.systemPackages = with pkgs; [ cacert pahi ];

  users.users.wasm = {
    isNormalUser = true;
    password = "hunter2";
  };
}
