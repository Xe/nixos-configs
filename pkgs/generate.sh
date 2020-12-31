#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nix-prefetch-github nix-prefetch-git jq

# github repos
nix-prefetch-github Xe rhea > ./rhea/source.json
nix-prefetch-github PonyvilleFM aura > ./aura/source.json
