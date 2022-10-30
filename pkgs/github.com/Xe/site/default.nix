{ fetchgit ? (import <nixpkgs> { }).fetchgit }:

(fetchgit (builtins.fromJSON (builtins.readFile ./source.json)))
