{fetchFromGitHub, stdenv}:

stdenv.mkDerivation {
  name = "GraphvizOnline";

  src = fetchFromGitHub (builtins.fromJSON (builtins.readFile ./source.json));

  phases = "installPhase";

  installPhase = ''
    mkdir -p $out
    cp -vrf $src/* $out
  '';
}
