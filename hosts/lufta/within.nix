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
      # webapps
      goproxy = {
        enable = true;
        useACME = true;
        domain = "cache.greedo.xeserv.us";
        port = 28381;
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

      idp.enable = true;
      johaus.enable = true;
      withinwebsite.enable = true;

      # bots
      aerial.enable = true;
      tron.enable = true;
      withinbot.enable = true;

      # IRC
      oragono.enable = true;

      # static sites
      lewa = {
        enable = true;
        useACME = true;
        domain = "lewa.within.website";
      };

      tulpaforce.enable = true;
      tulpanomicon.enable = true;
      graphviz.enable = true;
    };
  };
}
