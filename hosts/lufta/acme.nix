{ pkgs, ... }:

let
  creds = pkgs.writeTextFile {
    name = "cloudflare.env";
    text = builtins.readFile ./secret/acme-cf.env;
  };

  extraLegoFlags = [ "--dns.resolvers=8.8.8.8:53" ];

in {
  security.acme.defaults.email = "me@christine.website";
  security.acme.acceptTerms = true;

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
    dnsProvider = "cloudflare";
    credentialsFile = "${creds}";
    extraDomainNames =
      [ "*.tulpanomicon.guide" "tulpaforce.xyz" "*.tulpaforce.xyz" ];
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
