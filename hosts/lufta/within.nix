{ ... }:

{
  within = {
    backups = {
      enable = true;
      repo = "57196@usw-s007.rsync.net:lufta";
      paths = [
        "/srv"
        "/home/cadey/.weechat"
        "/home/mai/.weechat"
        "/var/lib/gitea"
        "/var/lib/acme"
      ];
    };
    services = {
      goproxy = {
        enable = true;
        useACME = true;
        domain = "cache.greedo.xeserv.us";
        port = 28381;
      };

      lewa = {
        enable = true;
        useACME = true;
        domain = "lewa.within.website";
      };

      hlang = {
        enable = true;
        useACME = true;
        domain = "h.christine.website";
      };

      mi = {
        enable = true;
        useACME = true;
        domain = "mi.within.website";
        port = 38184;
      };

      printerfacts = {
        enable = true;
        useACME = true;
        domain = "printerfacts.cetacean.club";
      };

      xesite = {
        enable = true;
        useACME = true;
        domain = "christine.website";
      };

      aerial.enable = true;
      graphviz.enable = true;
      idp.enable = true;
      johaus.enable = true;
      oragono.enable = true;
      tron.enable = true;
      tulpaforce.enable = true;
      tulpanomicon.enable = true;
      withinbot.enable = true;
      withinwebsite.enable = true;
    };
  };
}
