{ pkgs, ... }:

let
  creds = pkgs.writeTextFile {
    name = "cloudflare.env";
    text = builtins.readFile ./secret/acme-cf.env;
  };

  aws = pkgs.writeTextFile {
    name = "aws.env";
    text = builtins.readFile ./secret/aws.env;
  };

  extraLegoFlags = [ "--dns.resolvers=8.8.8.8:53" ];

in {
  security.acme.defaults.email = "me@christine.website";
  security.acme.acceptTerms = true;

  security.acme.certs."xeiaso.net" = {
    group = "nginx";
    email = "me@christine.website";
    dnsProvider = "route53";
    credentialsFile = "${aws}";
    extraDomainNames = [ "*.xeiaso.net" "xelaso.net" ];
    inherit extraLegoFlags;
  };

  security.acme.certs."tulpa.dev" = {
    group = "nginx";
    email = "me@christine.website";
    dnsProvider = "route53";
    credentialsFile = "${aws}";
    extraDomainNames = [ "*.tulpa.dev" ];
    inherit extraLegoFlags;
  };

  security.acme.certs."christine.website" = {
    group = "nginx";
    email = "me@christine.website";
    dnsProvider = "route53";
    credentialsFile = "${aws}";
    extraDomainNames = [ "*.christine.website" ];
    inherit extraLegoFlags;
  };

  security.acme.certs."cetacean.club" = {
    group = "nginx";
    email = "me@christine.website";
    dnsProvider = "route53";
    credentialsFile = "${aws}";
    extraDomainNames =
      [ "*.cetacean.club" "*.kahless.cetacean.club" "*.lufta.cetacean.club" ];
    inherit extraLegoFlags;
  };

  security.acme.certs."tulpanomicon.guide" = {
    group = "nginx";
    email = "me@christine.website";
    dnsProvider = "route53";
    credentialsFile = "${aws}";
    extraDomainNames = [ "*.tulpanomicon.guide" ];
    inherit extraLegoFlags;
  };

  security.acme.certs."tulpaforce.xyz" = {
    group = "nginx";
    email = "me@christine.website";
    dnsProvider = "route53";
    credentialsFile = "${aws}";
    extraDomainNames = [ "*.tulpaforce.xyz" ];
    inherit extraLegoFlags;
  };

  security.acme.certs."within.lgbt" = {
    group = "nginx";
    email = "me@christine.website";
    dnsProvider = "route53";
    credentialsFile = "${aws}";
    extraDomainNames = [ "*.within.lgbt" ];
    inherit extraLegoFlags;
  };

  security.acme.certs."within.website" = {
    group = "nginx";
    email = "me@christine.website";
    dnsProvider = "route53";
    credentialsFile = "${aws}";
    extraDomainNames = [ "*.within.website" ];
    inherit extraLegoFlags;
  };

  security.acme.certs."xeserv.us" = {
    group = "nginx";
    email = "me@christine.website";
    dnsProvider = "route53";
    credentialsFile = "${aws}";
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
    credentialsFile = "${aws}";
    extraDomainNames = [ "*.xn--u7hz981o.ws" ];
    inherit extraLegoFlags;
  };
}
