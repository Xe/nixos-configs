{ pkgs ? import <nixpkgs> { }, buildGoModule ? pkgs.buildGoModule
, fetchFromGitHub ? pkgs.fetchFromGitHub, lib ? pkgs.lib }:

buildGoModule rec {
  pname = "rhea";
  version = "0.1.0";

  src = fetchFromGitHub (builtins.fromJSON (builtins.readFile ./source.json));

  vendorSha256 = null;
}
