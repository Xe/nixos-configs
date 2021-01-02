{ pkgs ? import <nixpkgs> { }, fetchFromGitHub ? pkgs.fetchFromGitHub
, buildGoModule ? pkgs.buildGoModule }:

buildGoModule {
  pname = "goproxy";
  version = "yes";

  src = fetchFromGitHub (builtins.fromJSON (builtins.readFile ./source.json));

  vendorSha256 = "17pzn8jbdvgrb0gxn6hmd985q7024kk0x5qagi37g8v7053hx10m";
}
