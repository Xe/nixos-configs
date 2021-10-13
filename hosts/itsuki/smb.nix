{ config, pkgs, ... }:

{
  # https://nixos.wiki/wiki/Samba
  services.samba = {
    enable = true;
    securityType = "user";
    extraConfig = ''
      workgroup = WORKGROUP
      server string = itsuki
      netbios name = itsuki
      security = user 
      use sendfile = yes
      #max protocol = smb2
      hosts allow = 0.0.0.0/0
      hosts deny = 0.0.0.0/0
      guest account = nobody
      map to guest = bad user
    '';
    shares = {
      data = {
        path = "/data";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "cadey";
        "force group" = "within";
      };
    };
  };
}
