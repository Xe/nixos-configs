{ pkgs ? (import <nixpkgs> { }), fetchFromGitHub ? pkgs.fetchFromGitHub, callPackage ? pkgs.callPackage }:

import (fetchFromGitHub (builtins.fromJSON (builtins.readFile ./source.json)))
{ }
