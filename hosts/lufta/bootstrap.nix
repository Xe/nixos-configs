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
      # Add your own assigned ipv6 subnet here here!
      Address = 2a01:4f9:3a:1a1c::/64
      Gateway = fe80::1
      # optionally you can do the same for ipv4 and disable DHCP (networking.dhcpcd.enable = false;)
      Address =  135.181.162.99/26
      Gateway = 135.181.162.65
    '';
  };

  boot.supportedFilesystems = [ "zfs" ];

  environment.systemPackages = with pkgs; [ wget vim zfs ];
}
