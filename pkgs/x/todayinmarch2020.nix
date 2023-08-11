{ stdenv }:

stdenv.mkDerivation {
  name = "todayinmarch2020";
  src = builtins.fetchurl {
    url = (builtins.fromJSON "\"https://xena.greedo.xeserv.us/files/slugs/todayinmarch2020-202308111946.tar.gz\"");
    sha256 = (builtins.fromJSON "\"1giv3gh75xysg106gzr0w77bivn42q1g04cfs9jkl1rzzwd0ym8g\"");
  };

  phases = "installPhase";

  installPhase = ''
    tar xf $src
    mkdir -p $out/bin
    cp bin/main $out/bin/todayinmarch2020
  '';
}
