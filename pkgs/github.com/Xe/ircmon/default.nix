{fetchFromGitHub, stdenv}:

stdenv.mkDerivation {
  name = "ircmon-head";

  src = fetchFromGitHub (builtins.fromJSON (builtins.readFile ./source.json));

  phases = "installPhase";

  installPhase = ''
    mkdir -p $out
    cp -vrf $src/* $out
  '';
}
