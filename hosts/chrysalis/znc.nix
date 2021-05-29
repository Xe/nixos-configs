{config, pkgs, lib, ...}:

{
  services.znc = {
    enable = true;
    openFirewall = true;
    useLegacyConfig = false;

    config = {
      LoadModule = [ "webadmin" ];
      User.Mara = {
        Admin = true;
        Nick = "Mara";
        RealName = "Mara the Sh0rk";
        QuitMsg = "sh0rknap";
        LoadModule = [ "chansaver" "controlpanel" ];
        Pass.password = { # hunter2
          Method = "sha256";
          Hash =
            "b5dacf3284a5be6c96fd53b98b0e837fbb384e0692c79ac1d89022e40b873b2d";
          Salt = "?FdFUg:*tZ9niq9m5?xd";
        };
      };
    };
  };
}
