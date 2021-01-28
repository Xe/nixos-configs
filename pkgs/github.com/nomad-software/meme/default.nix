{ pkgs ? import <nixpkgs> { }, fetchFromGitHub ? pkgs.fetchFromGitHub
, buildGoModule ? pkgs.buildGoModule }:

buildGoModule {
  pname = "meme";
  version = "latest";

  src = fetchFromGitHub (builtins.fromJSON (builtins.readFile ./source.json));

  vendorSha256 = null;
}
