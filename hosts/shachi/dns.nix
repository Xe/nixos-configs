{ lib, ... }: {
  networking.nameservers = lib.mkForce [ "100.100.100.100" "10.77.2.2" "8.8.8.8" "1.1.1.1" ];
}
