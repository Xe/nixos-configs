{ pkgs ? import <nixpkgs> { }, fetchgit ? pkgs.fetchgit
, buildGoModule ? pkgs.buildGoModule }:

buildGoModule {
  name = "hlang";

  src = fetchgit (builtins.fromJSON (builtins.readFile ./source.json));

  vendorSha256 = "15ywhi6h7ia7bl3kfchdr8f7wnashii8wpg5559bcidzcdqs1k6c";
}
