{ pkgs, ... }:

{
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPg9gYKVglnO2HQodSJt4z4mNrUSUiyJQ7b+J798bwD9 cadey@shachi"
  ];

  networking.usePredictableInterfaceNames = false;
  systemd.network = {
    enable = true;
    networks."eth0".extraConfig = ''
      [Match]
      Name = eth0
      [Network]
      Address = 2607:5300:0060:1ccf::/64
      Gateway = 2607:5300:0060:1cff:ff:ff:ff:ff
      Address = 198.27.67.207/24
      Gateway = 198.27.67.254
      [Route]
      Destination=2607:5300:0060:1cff:ff:ff:ff:ff
      Scope=link
    '';
  };

  boot.supportedFilesystems = [ "zfs" ];

  environment.systemPackages = with pkgs; [ wget vim zfs ];
}
