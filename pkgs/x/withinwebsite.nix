{ stdenv }:

stdenv.mkDerivation {
  name = "within.website";
  src = builtins.fetchTarball {
    url =
      "https://xena.greedo.xeserv.us/files/slugs/within.website-091120192252.tar.gz";
    sha256 = "1c43w1smclyc2ziq4hcqk9cw0v14x12kan4bknsfccclxq6qacp8";
  };

  phases = "unpackPhase installPhase";

  installPhase = ''
    mkdir -p $out/bin
    cp $src/web $out/bin/withinwebsite
  '';
}
