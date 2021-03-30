let
  pkgs = import <nixpkgs> { };
  myPkgs = (import ./.) pkgs;
in rec {
  inherit (myPkgs) github xe tulpa within x;

  meme = github.com.nomad-software.meme;
  sw = github.com.jroimartin.sw;
  oragono = github.com.oragono.oragono;
  aura = github.com.PonyvilleFM.aura;

  GraphvizOnline = github.com.Xe.GraphvizOnline;
  mi = github.com.Xe.mi;
  rhea = github.com.Xe.rhea;
  xesite = github.com.Xe.site;
  withinbot = github.com.Xe.withinbot;

  cabytcini = tulpa.dev.cadey.cabytcini;
  lewa = tulpa.dev.cadey.lewa;
  hlang = tulpa.dev.cadey.hlang;
  printerfacts = tulpa.dev.cadey.printerfacts;
  tulpaforce = tulpa.dev.cadey.tulpaforce;
  tron = tulpa.dev.cadey.tron;

  tulpanomicon = tulpa.dev.tulpa-ebooks.tulpanomicon;
  quickserv = tulpa.dev.Xe.quickserv;

  caddy = x.caddy;
  idp = x.idp;
  withinwebsite = x.withinwebsite;
  johaus = x.johaus;
}
