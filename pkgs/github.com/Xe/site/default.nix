{ fetchgit ? (import <nixpkgs> { }).fetchgit }:

import (fetchgit (builtins.fromJSON (builtins.readFile ./source.json))) {}
