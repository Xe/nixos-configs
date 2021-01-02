{fetchFromGitHub, stdenv}:

stdenv.mkDerivation {
  pname = "sw";
  version = "git";

  src = fetchFromGitHub (builtins.fromJSON (builtins.readFile ./source.json));

  installPhase = ''
    DESTDIR=$out PREFIX=/ make install
    mkdir -p $out/share/sw
    install ./style.css $out/share/sw/style.css
    install ./sw.conf.def $out/share/sw/sw.conf.def
  '';
}
