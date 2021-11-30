{ stdenv }:

stdenv.mkDerivation {
  name = "within.website";
  src = builtins.fetchurl {
    url =
      "https://xena.greedo.xeserv.us/files/slugs/within.website-091120192252.tar.gz";
    sha256 = "14h9ibsrs708r0sk90yb0qlqzcxdfxq0cmir9v7w4acayw0f2f6n";
  };

  phases = "installPhase";

  installPhase = ''
    tar xf $src
    mkdir -p $out/bin
    cp bin/web $out/bin/withinwebsite
  '';
}
