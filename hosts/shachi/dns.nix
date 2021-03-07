{ lib, ... }: {
  networking.nameservers = lib.mkForce [ "100.100.100.100" "8.8.8.8" "1.1.1.1" ];
}
