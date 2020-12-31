{ pkgs ? import <nixpkgs> { }, buildGoModule ? pkgs.buildGoModule
, fetchFromGitHub ? pkgs.fetchFromGitHub, lib ? pkgs.lib }:

buildGoModule rec {
  pname = "aura";
  version = "HEAD";

  src = fetchFromGitHub (builtins.fromJSON (builtins.readFile ./source.json));

  vendorSha256 = null;
}
