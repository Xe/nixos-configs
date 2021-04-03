{ pkgs ? import <nixpkgs> { }, fetchgit ? pkgs.fetchgit
, buildGoModule ? pkgs.buildGoModule }:

buildGoModule {
  name = "aegis";

  src = fetchgit (builtins.fromJSON (builtins.readFile ./source.json));

  vendorSha256 = "0sjjj9z1dhilhpc8pq4154czrb79z9cm044jvn75kxcjv6v5l2m5";
}
