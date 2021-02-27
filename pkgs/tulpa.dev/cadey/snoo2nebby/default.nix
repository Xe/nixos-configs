{ pkgs ? import <nixpkgs> { }, fetchgit ? pkgs.fetchgit
, buildGoModule ? pkgs.buildGoModule }:

buildGoModule {
  pname = "snoo2nebby";
  version = "latest";

  src = fetchgit (builtins.fromJSON (builtins.readFile ./source.json));

  vendorSha256 = null;
}
