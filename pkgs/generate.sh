#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nix-prefetch-github nix-prefetch-git jq

function github() {
    mkdir -p ./github.com/$1/$2
    nix-prefetch-github $1 $2 > ./github.com/$1/$2/source.json
    echo "updated github.com/$1/$2"
}

function git() {
    mkdir -p ./$2
    nix-prefetch-git --quiet $1://$2.git | jq 'del(.date)' | jq 'del(.path)' > ./$2/source.json
    echo "updated $1://$2.git"
}

# github repos
github Xe rhea &
github PonyvilleFM aura &
github Xe site &
github Xe mi &

# git repos
git https tulpa.dev/cadey/dwm &
git https tulpa.dev/cadey/cabytcini &

wait
