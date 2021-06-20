{ config, ... }:

{
  boot = {
    initrd = {
      kernelModules = [ "r8169" ];
      network = {
        enable = true;
        ssh = {
          enable = true;
          port = 2222;
          authorizedKeys = config.users.users.cadey.openssh.authorizedKeys.keys;
          hostKeys = [
            "/etc/secrets/initrd/ssh_host_rsa_key"
            "/etc/secrets/initrd/ssh_host_ed25519_key"
          ];
        };
        postCommands = ''
          echo "zfs load-key -a; killall zfs" >> /root/.profile
        '';
      };
    };
  };
}
