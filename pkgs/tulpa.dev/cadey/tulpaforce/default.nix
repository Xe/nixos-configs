{ sw, stdenv, fetchgit, pandoc, ... }:

stdenv.mkDerivation {
  name = "tulpaforce-latest";

  src = fetchgit (builtins.fromJSON (builtins.readFile ./source.json));

  phases = "buildPhase installPhase";

  buildInputs = [sw pandoc];

  buildPhase = ''
    cp -vrf $src/site .
    cp -vrf $src/sw.conf .
    cp -vrf $src/style.css .
    sw site
  '';

  installPhase = ''
    mkdir -p $out
    cp -vrf ./site.static/* $out
  '';
}
