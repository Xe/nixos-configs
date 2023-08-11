{ stdenv }:

stdenv.mkDerivation {
  name = "within.website";
  src = builtins.fetchurl {
    url = (builtins.fromJSON "\"https://xena.greedo.xeserv.us/files/slugs/within.website-202308111926.tar.gz\"");
    sha256 = (builtins.fromJSON "\"1mcpmkkqr4l7sgxa1fgmk266rfcy0j1wa5rqd9zflc0l7x55pls8\"");
  };

  phases = "installPhase";

  installPhase = ''
    tar xf $src
    mkdir -p $out/bin
    cp bin/main $out/bin/withinwebsite
    cp config.ts $out/config.ts
  '';
}
