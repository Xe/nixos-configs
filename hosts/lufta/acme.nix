{ pkgs, ... }:

let
  creds = pkgs.writeTextFile {
    name = "cloudflare.env";
    text = builtins.readFile ./secret/acme-cf.env;
  };

  aws = {
    "cetacean.club" = pkgs.writeTextFile {
      name = "aws.env";
      text = builtins.readFile ./secret/aws-cetacean.club.env;
    };
    "christine.website" = pkgs.writeTextFile {
      name = "aws.env";
      text = builtins.readFile ./secret/aws-christine.website.env;
    };
    "pvfmsets.cf" = pkgs.writeTextFile {
      name = "aws.env";
      text = builtins.readFile ./secret/aws-pvfmsets.cf.env;
    };
    "tulpa.dev" = pkgs.writeTextFile {
      name = "aws.env";
      text = builtins.readFile ./secret/aws-tulpa.dev.env;
    };
    "tulpaforce.tk" = pkgs.writeTextFile {
      name = "aws.env";
      text = builtins.readFile ./secret/aws-tulpaforce.tk.env;
    };
    "tulpaforce.xyz" = pkgs.writeTextFile {
      name = "aws.env";
      text = builtins.readFile ./secret/aws-tulpaforce.xyz.env;
    };
    "tulpanomicon.guide" = pkgs.writeTextFile {
      name = "aws.env";
      text = builtins.readFile ./secret/aws-tulpanomicon.guide.env;
    };
    "within.website" = pkgs.writeTextFile {
      name = "aws.env";
      text = builtins.readFile ./secret/aws-within.website.env;
    };
    "xeiaso.net" = pkgs.writeTextFile {
      name = "aws.env";
      text = builtins.readFile ./secret/aws-xeiaso.net.env;
    };
    "xeserv.us" = pkgs.writeTextFile {
      name = "aws.env";
      text = builtins.readFile ./secret/aws-xeserv.us.env;
    };
    "xn--sz8hf6d.ws" = pkgs.writeTextFile {
      name = "aws.env";
      text = builtins.readFile ./secret/aws-xn--sz8h6fd.ws.env;
    };
    "xn--u7hz981o.ws" = pkgs.writeTextFile {
      name = "aws.env";
      text = builtins.readFile ./secret/aws-xn--u7hz981o.ws.env;
    };
  };

  extraLegoFlags = [ "--dns.resolvers=8.8.8.8:53" ];

in {
  security.acme.defaults.email = "me@christine.website";
  security.acme.acceptTerms = true;

  security.acme.certs."xeiaso.net" = {
    group = "nginx";
    email = "me@christine.website";
    dnsProvider = "route53";
    credentialsFile = "${aws."xeiaso.net"}";
    extraDomainNames = [ "*.xeiaso.net" ];
    inherit extraLegoFlags;
  };

  security.acme.certs."tulpa.dev" = {
    group = "nginx";
    email = "me@christine.website";
    dnsProvider = "route53";
    credentialsFile = "${aws."tulpa.dev"}";
    extraDomainNames = [ "*.tulpa.dev" ];
    inherit extraLegoFlags;
  };

  security.acme.certs."christine.website" = {
    group = "nginx";
    email = "me@christine.website";
    dnsProvider = "route53";
    credentialsFile = "${aws."christine.website"}";
    extraDomainNames = [ "*.christine.website" ];
    inherit extraLegoFlags;
  };

  security.acme.certs."cetacean.club" = {
    group = "nginx";
    email = "me@christine.website";
    dnsProvider = "route53";
    credentialsFile = "${aws."cetacean.club"}";
    extraDomainNames =
      [ "*.cetacean.club" "*.kahless.cetacean.club" "*.lufta.cetacean.club" ];
    inherit extraLegoFlags;
  };

  security.acme.certs."pvfmsets.cf" = {
    group = "nginx";
    email = "me@christine.website";
    dnsProvider = "route53";
    credentialsFile = "${aws."pvfmsets.cf"}";
    inherit extraLegoFlags;
  };

  security.acme.certs."tulpanomicon.guide" = {
    group = "nginx";
    email = "me@christine.website";
    dnsProvider = "route53";
    credentialsFile = "${aws."tulpanomicon.guide"}";
    extraDomainNames =
      [ "*.tulpanomicon.guide" ];
    inherit extraLegoFlags;
  };

  security.acme.certs."tulpaforce.xyz" = {
    group = "nginx";
    email = "me@christine.website";
    dnsProvider = "route53";
    credentialsFile = "${aws."tulpaforce.xyz"}";
    extraDomainNames =
      [ "*.tulpaforce.xyz" ];
    inherit extraLegoFlags;
  };

  security.acme.certs."within.website" = {
    group = "nginx";
    email = "me@christine.website";
    dnsProvider = "route53";
    credentialsFile = "${aws."within.website"}";
    extraDomainNames = [ "*.within.website" ];
    inherit extraLegoFlags;
  };

  security.acme.certs."xeserv.us" = {
    group = "nginx";
    email = "me@christine.website";
    dnsProvider = "route53";
    credentialsFile = "${aws."xeserv.us"}";
    extraDomainNames = [
      "*.xeserv.us"
      "*.greedo.xeserv.us"
      "*.apps.xeserv.us"
      "*.minipaas.xeserv.us"
    ];
    inherit extraLegoFlags;
  };

  security.acme.certs."xn--u7hz981o.ws" = {
    group = "nginx";
    email = "me@christine.website";
    dnsProvider = "route53";
    credentialsFile = "${aws."xn--u7hz981o.ws"}";
    extraDomainNames = [ "*.xn--u7hz981o.ws" ];
    inherit extraLegoFlags;
  };
}
