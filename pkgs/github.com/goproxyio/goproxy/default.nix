{ pkgs ? import <nixpkgs> { }, fetchFromGitHub ? pkgs.fetchFromGitHub
, buildGoModule ? pkgs.buildGoModule }:

buildGoModule {
  pname = "goproxy";
  version = "yes";

  src = fetchFromGitHub (builtins.fromJSON (builtins.readFile ./source.json));

  vendorSha256 = "1d4i3c36fqzmcp4pfdzqshyvxd9j7ncpgxirdn73cg3hbqk44sch";
}
