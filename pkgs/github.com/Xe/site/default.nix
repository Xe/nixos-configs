{ fetchgit ? (import <nixpkgs> { }).fetchgit }:

let meta = builtins.fromJSON (builtins.readFile ./source.json);
    src = fetchgit meta;
    flake = import src;
in flake.default
