{ pkgs, ... }:

let
  creds = pkgs.writeTextFile {
    name = "cloudflare.env";
    text = builtins.readFile ./secret/acme-cf.env;
  };

  aws = {
    "tulpanomicon.guide" = pkgs.writeTextFile {
      name = "aws.env";
      text = builtins.readFile ./secret/aws-tulpanomicon.guide.env;
    };
    "tulpaforce.xyz" = pkgs.writeTextFile {
      name = "aws.env";
      text = builtins.readFile ./secret/aws-tulpaforce.xyz.env;
    };
  };

  extraLegoFlags = [ "--dns.resolvers=8.8.8.8:53" ];

in {
  security.acme.defaults.email = "me@christine.website";
  security.acme.acceptTerms = true;

  security.acme.certs."xeiaso.net" = {
    group = "nginx";
    email = "me@christine.website";
    dnsProvider = "cloudflare";
    credentialsFile = "${creds}";
    extraDomainNames = [ "*.xeiaso.net" ];
    inherit extraLegoFlags;
  };

  security.acme.certs."tulpa.dev" = {
    group = "nginx";
    email = "me@christine.website";
    dnsProvider = "cloudflare";
    credentialsFile = "${creds}";
    extraDomainNames = [ "*.tulpa.dev" ];
    inherit extraLegoFlags;
  };

  security.acme.certs."christine.website" = {
    group = "nginx";
    email = "me@christine.website";
    dnsProvider = "cloudflare";
    credentialsFile = "${creds}";
    extraDomainNames = [ "*.christine.website" ];
    inherit extraLegoFlags;
  };

  security.acme.certs."cetacean.club" = {
    group = "nginx";
    email = "me@christine.website";
    dnsProvider = "cloudflare";
    credentialsFile = "${creds}";
    extraDomainNames =
      [ "*.cetacean.club" "*.kahless.cetacean.club" "*.lufta.cetacean.club" ];
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
    dnsProvider = "cloudflare";
    credentialsFile = "${creds}";
    extraDomainNames = [ "*.within.website" ];
    inherit extraLegoFlags;
  };

  security.acme.certs."xeserv.us" = {
    group = "nginx";
    email = "me@christine.website";
    dnsProvider = "cloudflare";
    credentialsFile = "${creds}";
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
    dnsProvider = "cloudflare";
    credentialsFile = "${creds}";
    extraDomainNames = [ "*.xn--u7hz981o.ws" "*.xn--sz8hf6d.ws" ];
    inherit extraLegoFlags;
  };
}
