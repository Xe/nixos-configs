{ config, ... }:

let
  paths = [
    "/srv"
    "/home/cadey/.weechat"
    "/home/mai/.weechat"
    "/home/cadey/life"
    "/home/cadey/org"
    "/var/lib/acme"
    "/var/lib/gitea"
    "/var/lib/mysql"
    "/var/lib/tor/onion"
    "/srv/http/xena.greedo.xeserv.us/articles"
    "/srv/http/xena.greedo.xeserv.us/books"
    "/srv/http/xena.greedo.xeserv.us/css"
    "/srv/http/xena.greedo.xeserv.us/fics"
    "/srv/http/xena.greedo.xeserv.us/pkg"
    "/srv/http/xena.greedo.xeserv.us/repo"
    "/srv/http/xena.greedo.xeserv.us/templates"
    "/srv/http/xena.greedo.xeserv.us/tumblr"
    "/home/cadey/prefix/flightjournal"
    "/run/keys"
    "/home/cadey/backup/ponychat"
    "/home/cadey/backup/shadowh511"
  ];
  exclude = [
    # temporary files created by cargo
    "**/target"
    "/home/cadey/prefix/aura"
    "/srv/within/aura"
    "/srv/http/xena.greedo.xeserv.us"

    "/var/lib/docker"
    "/var/lib/systemd"
    "/var/lib/libvirt"
    "'**/.cache'"
    "'**/.nix-profile'"
    "'**/.elm'"
    "'**/.emacs.d'"
  ];
in {
  services.borgbackup.jobs."hetzner" = {
    paths = paths ++ [
      "/home/cadey/go/src"
      "/home/cadey/code"
      "/home/cadey/prefix"
      "/home/cadey/backup/construct"
      "/home/cadey/backup/greedo"
      "/home/cadey/backup/luna"
      "/home/cadey/backup/tulpa"
    ];
    inherit exclude;
    repo = "ssh://u252481@u252481.your-storagebox.de:23/./lufta";
    encryption = {
      mode = "repokey-blake2";
      passCommand = "cat /run/keys/borgbackup_passphrase";
    };
    environment.BORG_RSH = "ssh -i /root/.ssh/id_rsa";
    compression = "auto,lzma";
    startAt = "daily";
  };

  within = {
    backups = {
      inherit exclude paths;
      enable = true;
      repo = "57196@usw-s007.rsync.net:lufta";
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
