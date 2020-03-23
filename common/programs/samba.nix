{ config, pkgs, lib, ... }:

{
  services.samba = {
    enable = true;
    securityType = "user";
    extraConfig = ''
      workgroup = WORKGROUP
      server string = shachi
      netbios name = shachi
      security = user
      #use sendfile = yes
      #max protocol = smb2
      hosts allow = 0.0.0.0/0
      guest account = nobody
      map to guest = bad user
      ntlm auth = true
      signing_required = no
    '';
    shares = {
      public = {
        path = "/data";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "cadey";
        "force group" = "cadey";
      };
    };
  };
}
