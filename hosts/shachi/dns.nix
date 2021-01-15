{ lib, ... }: {
  networking.nameservers = lib.mkForce [ "10.77.2.2" "8.8.8.8" "1.1.1.1" ];
}
