{ pkgs ? import <nixpkgs> { }, fetchgit ? pkgs.fetchgit
, buildGoModule ? pkgs.buildGoModule }:

buildGoModule {
  name = "hlang";

  src = fetchgit (builtins.fromJSON (builtins.readFile ./source.json));

  vendorSha256 = "1qg7ddriw5cvbsc8685hqzn3swl1nr1cg22r8pp2lrdwfcj14rdp";
}
