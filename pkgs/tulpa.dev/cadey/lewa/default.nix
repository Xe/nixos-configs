{ pkgs ? (import <nixpkgs> { }), fetchgit ? pkgs.fetchgit, callPackage ? pkgs.callPackage }:

callPackage
(fetchgit (builtins.fromJSON (builtins.readFile ./source.json))) { }
